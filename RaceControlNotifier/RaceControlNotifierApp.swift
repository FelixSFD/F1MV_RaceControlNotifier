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
    
    
    @State var notifier = RCMNotifier(fetcher: RCMFetcher(), textToSpeech: tts)
    
    @StateObject private var sca = ObservableSCA()
    
    @StateObject private var bonjour = DisvoceredDevicesViewModel()
    
    
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    
    
    var body: some Scene {
        let settingsWindow = SettingsView()
        let messagesListView = MessageListView(rcmNotifier: notifier, tts: RaceControlNotifierApp.tts)
        
        WindowGroup("All Messages", id: "all_messages.window") {
            messagesListView
                .environmentObject(sca)
        }
        
        WindowGroup("Settings", id: "settings.window") {
            settingsWindow
                .environmentObject(sca)
                .environmentObject(bonjour)
        }
        
        MenuBarExtra(
            "App Menu Bar Extra", systemImage: "radio.fill",
            isInserted: $showMenuBarExtra)
        {
            MenuBarListView()
        }
    }
}
