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

#if os(macOS)
import SDWebImageSwiftUI
import SimplyCoreAudio
#endif


class TextViewModel: ObservableObject {
    @Published var text: String
    
    
    init(text: String) {
        self.text = text
        print("init with text: " + text)
    }
}


struct SettingsView: View {
    #if os(macOS)
    private static let simplyCA = SimplyCoreAudio()
    
    @EnvironmentObject var sca: ObservableSCA
    #endif
    
    @State var toggleFlagsState = UserDefaults.standard.announceFlags
    @State var toggleDeletedTimesState = UserDefaults.standard.announceDeletedLaps
    @State var toggleMissedApexState = UserDefaults.standard.announceMissedApex
    @State var toggleOffTrackState = UserDefaults.standard.announceOffTrack
    @State var toggleSpunState = UserDefaults.standard.announceSpun
    
    @ObservedObject private var apiBaseUrlTextViewModel = TextViewModel(text: UserDefaults.standard.apiUrl)
    
    @State var hoverFlagName: String? = nil
    
    @State var flagToggleItems: [EnumToggleList.ItemModel] = getAvailableFlagItems()
    
    #if os(macOS)
    @State var selectedAudioDevice: ObservableAudioDevice?
    #endif
    
    
    private static func getAvailableFlagItems() -> [EnumToggleList.ItemModel] {
        FlagColor.allCases.map { flagColor in
            return EnumToggleList.ItemModel(code: flagColor.rawValue, label: flagColor.description, isEnabled: false)
        }
    }
    
    
    private static func GetSettingsToggle(forKey key: String, defaultValue: Bool = false) -> Bool {
        return UserDefaults.standard.object(forKey: key) as? Bool ?? defaultValue
    }
    
    
    private static func SaveSettingsToggle(forKey key: String, _ newValue: Bool) {
        UserDefaults.standard.set(newValue, forKey: key)
    }
    
    
    #if os(macOS)
    private func getOutputDevice() -> ObservableAudioDevice? {
        guard let selectedId = UserDefaults.standard.selectedAudioDeviceId else {
            return nil
        }
        
        return sca.devices.first { availableDevice in
            return availableDevice.id.description == selectedId
        }
    }
    #endif
    
    
    private func saveEverything() {
        print("Save form")
        SettingsView.SaveSettingsToggle(forKey: Constants.Settings.Keys.announceFlags, toggleFlagsState)
        
        // all enabled flags. Not only those who have been added
        var newEnabledFlags: [FlagColor] = []
        for flagStatus in flagToggleItems {
            print("Flag \(flagStatus.code): \(flagStatus.isEnabled ? "ENABLED" : "DISABLED")")
            if flagStatus.isEnabled {
                if let safeFlagColor = FlagColor(rawValue: flagStatus.code) {
                    newEnabledFlags.append(safeFlagColor)
                }
            }
        }
        
        UserDefaults.standard.announceFlagsEnabled = newEnabledFlags
        
        SettingsView.SaveSettingsToggle(forKey: Constants.Settings.Keys.announceDeletedLaps, toggleDeletedTimesState)
        SettingsView.SaveSettingsToggle(forKey: Constants.Settings.Keys.announceMissedApex, toggleMissedApexState)
        SettingsView.SaveSettingsToggle(forKey: Constants.Settings.Keys.announceOffTrack, toggleOffTrackState)
        SettingsView.SaveSettingsToggle(forKey: Constants.Settings.Keys.announceSpun, toggleSpunState)
        
        UserDefaults.standard.set(apiBaseUrlTextViewModel.text, forKey: Constants.Settings.Keys.apiUrl)
        
        #if os(macOS)
        UserDefaults.standard.set(selectedAudioDevice?.id, forKey: Constants.Settings.Keys.selectedOutputDevice)
        sca.loadDefaultDeviceFromUserDefaults()
        #endif
        
        print("successfully saved")
    }
    
    
    var body: some View {
        #if os(macOS)
        TabView {
            VStack(alignment: .leading) {
                SettingsMessagesView(toggleDeletedTimesState: $toggleDeletedTimesState, toggleMissedApexState: $toggleMissedApexState, toggleOffTrackState: $toggleOffTrackState, toggleSpunState: $toggleSpunState, toggleFlagsState: $toggleFlagsState, flagToggleItems: $flagToggleItems)
            }
            .tabItem {
                Text("Messages")
            }
            
            VStack(alignment: .leading) {
                Text("Output device:")
                List(sca.devices, id: \.self, selection: $selectedAudioDevice) {
                    device in
                    Text(device.name)
                }
            }
            .tabItem {
                Text("Audio")
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Base URL:")
                    TextField("http://...", text: $apiBaseUrlTextViewModel.text)
                }
                .padding()
                
                Spacer()
            }
            .tabItem {
                Text("API Configuration")
            }
        }
        .padding()
        .frame(minWidth: 300, idealWidth: 350, minHeight: 300, idealHeight: 450)
        
        VStack {
            Button("Save") {
                self.saveEverything()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .padding()
        .onAppear {
            self.selectedAudioDevice = getOutputDevice()
        }
        
        #else
        
        // iOS
        
        NavigationView {
            List {
                NavigationLink {
                    SettingsMessagesView(toggleDeletedTimesState: $toggleDeletedTimesState, toggleMissedApexState: $toggleMissedApexState, toggleOffTrackState: $toggleOffTrackState, toggleSpunState: $toggleSpunState, toggleFlagsState: $toggleFlagsState, flagToggleItems: $flagToggleItems)
                } label: {
                    Text("Messages")
                }

            }
            .navigationTitle("Settings")
            .toolbar {
                Button("Save") {
                    self.saveEverything()
                }
            }
        }
        
        #endif
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
