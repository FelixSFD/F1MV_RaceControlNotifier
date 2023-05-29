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

import SwiftUI
import AVFAudio

@main
struct RaceControlNotifierApp: App {    
    /// Object that handles the speech
    private static let tts = TextToSpeech(voiceId: UserDefaults.standard.voiceId)
    
    
    @State var notifier = RCMNotifier(fetcher: RCMFetcher(), textToSpeech: tts)
    
    #if os(macOS)
    @StateObject private var sca = ObservableSCA()
    #endif
    
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    
    
    var body: some Scene {
        let settingsWindow = SettingsNavView()
        let messagesListView = MessageListView()
        
        #if os(macOS)
        WindowGroup("All Messages", id: "all_messages.window") {
            messagesListView
                .environmentObject(sca)
                .environmentObject(RaceControlNotifierApp.tts)
                .environmentObject(notifier)
        }
        
        WindowGroup("Settings", id: "settings.window") {
            settingsWindow
                .listStyle(.sidebar)
                .environmentObject(sca)
                .environmentObject(RaceControlNotifierApp.tts)
        }
        
        MenuBarExtra(
            "App Menu Bar Extra", systemImage: "radio.fill",
            isInserted: $showMenuBarExtra)
        {
            MenuBarListView()
        }
        #else
        
        WindowGroup {
            TabView {
                MessageListNavView()
                    .environmentObject(RaceControlNotifierApp.tts)
                    .environmentObject(notifier)
                    .tabItem {
                        Image(systemName: "message.and.waveform")
                        Text("Messages")
                    }
                
                SettingsNavView()
                    .environmentObject(RaceControlNotifierApp.tts)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .onAppear {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                } catch {
                    print("Could not activate audio")
                }
            }
        }
        
        #endif
    }
}
