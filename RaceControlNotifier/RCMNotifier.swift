//
// RaceControlNotifier for MultiViewer
// Copyright (c) 2022  FelixSFD
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see https://www.gnu.org/licenses/.

import Foundation


class RCMNotifier: ObservableObject {
    private let fetcher: RCMFetcher
    
    
    private var messages: [RaceControlMessageModel] = []
    
    
    private let tts: TextToSpeech
    
    var observer: NSKeyValueObservation?
    
    
    /// Reversed messages to make it easier to display the latest message on top
    @Published var reversedMessages: [RaceControlMessageModel] = []
    
    
    init(fetcher: RCMFetcher, textToSpeech: TextToSpeech) {
        self.fetcher = fetcher
        self.tts = textToSpeech
        start()
    }
    
    
    private func startObservingSettings() {
        observer = UserDefaults.standard.observe(\.apiUrl, options: [.initial, .new], changeHandler: { (defaults, change) in
            // your change logic here
            self.fetcher.apiBaseUrl = defaults.apiUrl
        })
    }
    
    
    deinit {
        observer?.invalidate()
    }
    
    
    public func start() {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            Task {
                await self.fetchNewMessages()
            }
        }
        
        startObservingSettings()
    }
    
    
    func fetchNewMessages() async {
        let latestMessageDate = messages.last?.date ?? Date.distantPast
        
        let speakMessages = !messages.isEmpty
        
        var newlyAddedMessages: [RaceControlMessageModel] = []
        
        do {
            let allMessages = try await fetcher.getMessages()
            allMessages.forEach {
                newMessage1 in
                var newMessage = newMessage1
                let announceEnabled = messageAnnouncementEnabled(newMessage)
                newMessage.ttsEnabled = announceEnabled
                
                if newMessage.date > latestMessageDate {
                    self.messages.append(newMessage)
                    newlyAddedMessages.insert(newMessage, at: 0)
                    print("Added: \(newMessage.message)")
                    print(newMessage.date)
                    
                    if speakMessages && announceEnabled {
                        tts.say(newMessage.message)
                    }
                }
            }
        }
        catch {
            print(error)
        }
        
        DispatchQueue.main.async {
            [newlyAddedMessages] in
            print("Will add messages to public array")
            self.reversedMessages.insert(contentsOf: newlyAddedMessages, at: 0)
            print("Added messages to public array")
        }
    }
    
    
    func messageAnnouncementEnabled(_ message: RaceControlMessageModel) -> Bool {
        switch message.category {
        case .flag:
            if !UserDefaults.standard.bool(forKey: "announce.flags") {
                return false
            }
            
            guard let safeFlagColor = message.flag else {
                return false
            }
            
            return flagAnnouncementEnabled(safeFlagColor)
        case .missedApex:
            return UserDefaults.standard.bool(forKey: "announce.missedApex")
        case .offTrack:
            return UserDefaults.standard.bool(forKey: "announce.offTrack")
        case .spun:
            return UserDefaults.standard.bool(forKey: "announce.mazespin")
        case .other:
            return true
        }
    }
    
    
    func flagAnnouncementEnabled(_ flag: FlagColor) -> Bool {
        let settingsKey: String
        switch flag {
        case .green:
            settingsKey = "announce.flags.green"
            break;
        case .blue:
            settingsKey = "announce.flags.blue"
            break;
        case .yellow:
            settingsKey = "announce.flags.yellow"
            break;
        case .doubleYellow:
            settingsKey = "announce.flags.doubleYellow"
            break;
        case .red:
            settingsKey = "announce.flags.red"
            break;
        case .chequered:
            settingsKey = "announce.flags.chequered"
            break;
        case .meatball:
            settingsKey = "announce.flags.meatball"
            break;
        case .blackWhite:
            settingsKey = "announce.flags.blackWhite"
            break;
//        default:
//            print("unexpected flag!")
//            return true
        }
        
        return UserDefaults.standard.bool(forKey: settingsKey)
    }
}
