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

@main
struct RaceControlNotifierApp: App {    
    /// Object that handles the speech
    private static let tts = TextToSpeech()
    
    
    @StateObject var notifier = RCMNotifier(fetcher: RCMFetcher(), textToSpeech: tts)
    
    
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    
    
    var body: some Scene {
        let settingsWindow = SettingsView()
        let messagesListView = MessageListView(messages: $notifier.reversedMessages, tts: RaceControlNotifierApp.tts)
        
        //WindowGroup {
        //    messagesListView
        //}
        
        WindowGroup("All Messages", id: "all_messages.window") {
            messagesListView
        }
        
        WindowGroup("Settings", id: "settings.window") {
            settingsWindow
        }
        
        MenuBarExtra(
            "App Menu Bar Extra", systemImage: "radio.fill",
            isInserted: $showMenuBarExtra)
        {
            MenuBarListView()
        }
    }
}
