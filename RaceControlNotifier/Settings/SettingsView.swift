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
import SDWebImageSwiftUI


class TextViewModel: ObservableObject {
    @Published var text: String
    
    
    init(text: String) {
        self.text = text
        print("init with text: " + text)
    }
}


struct SettingsView: View {
    @State var toggleFlagsState = GetSettingsToggle(forKey: Constants.Settings.Keys.announceFlags, defaultValue: true)
    
    @State var toggleFlagBlueState = GetSettingsToggle(forKey: "announce.flags.blue", defaultValue: false)
    @State var toggleFlagChequeredState = GetSettingsToggle(forKey: "announce.flags.chequered", defaultValue: true)
    @State var toggleFlagYellowState = GetSettingsToggle(forKey: "announce.flags.yellow", defaultValue: true)
    @State var toggleFlagDoubleYellowState = GetSettingsToggle(forKey: "announce.flags.doubleYellow", defaultValue: true)
    @State var toggleFlagGreenState = GetSettingsToggle(forKey: "announce.flags.green", defaultValue: true)
    @State var toggleFlagRedState = GetSettingsToggle(forKey: "announce.flags.red", defaultValue: true)
    @State var toggleFlagMeatballState = GetSettingsToggle(forKey: "announce.flags.meatball", defaultValue: true)
    @State var toggleFlagBlackWhiteState = GetSettingsToggle(forKey: "announce.flags.blackWhite", defaultValue: true)
    
    
    @State var toggleDeletedTimesState = GetSettingsToggle(forKey: Constants.Settings.Keys.announceDeletedLaps, defaultValue: true)
    @State var toggleMissedApexState = GetSettingsToggle(forKey: Constants.Settings.Keys.announceMissedApex, defaultValue: true)
    @State var toggleOffTrackState = GetSettingsToggle(forKey: Constants.Settings.Keys.announceOffTrack, defaultValue: true)
    @State var toggleSpunState = GetSettingsToggle(forKey: Constants.Settings.Keys.announceSpun, defaultValue: true)
    
    
    //@State var apiBaseUrl = UserDefaults.standard.string(forKey: "api.url") ?? ""
    @ObservedObject private var apiBaseUrlTextViewModel = TextViewModel(text: UserDefaults.standard.apiUrl)
    
    
    @State var hoverFlagName: String? = nil
    
    @State var flagToggleItems: [EnumToggleList.ItemModel] = getAvailableFlagItems()
    
    
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
    
    
    var body: some View {
        TabView {
            VStack(alignment: .leading) {
                Toggle(isOn: $toggleDeletedTimesState) {
                    Text("Announce deleted lap-times")
                }
                
                Toggle(isOn: $toggleMissedApexState) {
                    Text("Announce \"missed apex\"-messages")
                }
                
                Toggle(isOn: $toggleOffTrackState) {
                    Text("Announce \"off track and continued\"-messages")
                }
                
                Toggle(isOn: $toggleSpunState) {
                    Text("Announce \"spun\"-messages")
                }
                
                Toggle(isOn: $toggleFlagsState) {
                    Text("Announce flags")
                }

                List {
                    EnumToggleList(items: $flagToggleItems)
                }
                .padding(.leading)
                .onAppear {
                    let enabledFlags = UserDefaults.standard.announceFlagsEnabled
                    print("All enabled flags: \(enabledFlags)")
                    for flagToggleItemIndex in flagToggleItems.indices {
                        print("Check if flag is enabled: \(flagToggleItems[flagToggleItemIndex].code)")
                        flagToggleItems[flagToggleItemIndex].isEnabled = enabledFlags.contains(where: { enabledFlag in
                            print("Check flag \(enabledFlag.rawValue) with ID \(flagToggleItems[flagToggleItemIndex].code)")
                            return enabledFlag.rawValue == flagToggleItems[flagToggleItemIndex].code
                        })
                    }
                }
            }
            .tabItem {
                Text("Messages")
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
        
        VStack {
            Button("Save") {
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
                
                print("successfully saved")
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
