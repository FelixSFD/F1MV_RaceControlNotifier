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
import SimplyCoreAudio
import Bonjour


class TextViewModel: ObservableObject {
    @Published var text: String
    
    
    init(text: String) {
        self.text = text
        print("init with text: " + text)
    }
}


struct SettingsView: View {
    @EnvironmentObject var sca: ObservableSCA
    @EnvironmentObject var bonjour: DisvoceredDevicesViewModel
    
    @State var toggleFlagsState = UserDefaults.standard.announceFlags
    @State var toggleDeletedTimesState = UserDefaults.standard.announceDeletedLaps
    @State var toggleMissedApexState = UserDefaults.standard.announceMissedApex
    @State var toggleOffTrackState = UserDefaults.standard.announceOffTrack
    @State var toggleSpunState = UserDefaults.standard.announceSpun
    
    @ObservedObject private var apiBaseUrlTextViewModel = TextViewModel(text: UserDefaults.standard.apiUrl)
    
    @State var hoverFlagName: String? = nil
    
    @State var flagToggleItems: [EnumToggleList.ItemModel] = getAvailableFlagItems()
    
    @State var selectedAudioDevice: ObservableAudioDevice?
    
    @State var apiHostSelectedPeer: Peer? = nil
    @State var apiHostSearchLoading: Bool = false
    @State var apiHostOverwriteUrlAlertShowing: Bool = false
    
    
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
    
    
    private func getOutputDevice() -> ObservableAudioDevice? {
        guard let selectedId = UserDefaults.standard.selectedAudioDeviceId else {
            return nil
        }
        
        return sca.devices.first { availableDevice in
            return availableDevice.id.description == selectedId
        }
    }
    
    
    var body: some View {
        TabView {
            VStack(alignment: .leading) {
                List {
                    Section("General messages") {
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
                    }
                    Section("Flags") {
                        // Master-toggle
                        Toggle(isOn: $toggleFlagsState) {
                            Text("Announce flags")
                                .bold()
                        }
                        
                        // Toggles for every flag-color
                        EnumToggleList(items: $flagToggleItems, allWriteable: $toggleFlagsState)
                            .padding(.leading)
                    }
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
                .listStyle(.inset)
                .toggleStyle(.switch) // set switch-style for everything in the list
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
                
                Spacer()
                Spacer()
                
                HStack {
                    Text("Searching MultiViewer API hosts in your local network")
                    ActivityIndicator($apiHostSearchLoading, style: .medium)
                }
                ApiHostSelectionView(viewModel: ApiHostSelectionView.ViewModel(selectedPeer: $apiHostSelectedPeer))
            }
            .padding()
            .tabItem {
                Text("API Configuration")
            }
            .onAppear {
                apiHostSearchLoading = true
                bonjour.startDiscovery()
            }
            .onDisappear {
                bonjour.stopDiscovery()
                apiHostSearchLoading = false
            }
            .onChange(of: apiHostSelectedPeer) { newValue in
                apiHostOverwriteUrlAlertShowing = newValue != nil
            }
            .alert(isPresented: $apiHostOverwriteUrlAlertShowing) {
                Alert(
                    title: Text("Overwrite API-URL?"),
                    message: Text("Do you want to overwrite the API-URL based on the address of the device '\(apiHostSelectedPeer?.name ?? "unknown device")'?"),
                    primaryButton: .default(Text("Overwrite")) {
                        print("Overwriting url...")
                        print(apiHostSelectedPeer?.discoveryInfo)
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .padding()
        .frame(minWidth: 300, idealWidth: 350, minHeight: 300, idealHeight: 450)
        
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
                
                UserDefaults.standard.set(selectedAudioDevice?.id, forKey: Constants.Settings.Keys.selectedOutputDevice)
                sca.loadDefaultDeviceFromUserDefaults()
                
                print("successfully saved")
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .padding()
        .onAppear {
            self.selectedAudioDevice = getOutputDevice()
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject({ () -> ObservableSCA in
                return ObservableSCA()
            }())
            .environmentObject({ () -> DisvoceredDevicesViewModel in
                return MockDisvoceredDevicesViewModel()
            }())
    }
}
