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

struct SettingsView: View {
    @State var toggleFlagsState = GetSettingsToggle(forKey: "announce.flags", defaultValue: true)
    
    @State var toggleFlagBlueState = GetSettingsToggle(forKey: "announce.flags.blue", defaultValue: false)
    @State var toggleFlagChequeredState = GetSettingsToggle(forKey: "announce.flags.chequered", defaultValue: true)
    @State var toggleFlagYellowState = GetSettingsToggle(forKey: "announce.flags.yellow", defaultValue: true)
    @State var toggleFlagDoubleYellowState = GetSettingsToggle(forKey: "announce.flags.doubleYellow", defaultValue: true)
    @State var toggleFlagGreenState = GetSettingsToggle(forKey: "announce.flags.green", defaultValue: true)
    @State var toggleFlagRedState = GetSettingsToggle(forKey: "announce.flags.red", defaultValue: true)
    @State var toggleFlagMeatballState = GetSettingsToggle(forKey: "announce.flags.meatball", defaultValue: true)
    
    
    @State var toggleDeletedTimesState = GetSettingsToggle(forKey: "announce.deletedLaps", defaultValue: true)
    @State var toggleMissedApexState = GetSettingsToggle(forKey: "announce.missedApex", defaultValue: true)
    @State var toggleOffTrackState = GetSettingsToggle(forKey: "announce.offTrack", defaultValue: true)
    @State var toggleSpunState = GetSettingsToggle(forKey: "announce.mazespin", defaultValue: true)
    
    
    @State var apiBaseUrl = UserDefaults.standard.string(forKey: "api.url") ?? ""
    
    
    @State var hoverFlagName: String? = nil
    
    
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
                
                VStack(alignment: .leading) {
                    FlagToggleView(viewModel: FlagToggleView.ViewModel(toggleState: $toggleFlagDoubleYellowState, selctedGifName: $hoverFlagName, label: "Double yellow", gifName: "dyellow.gif"))
                        .disabled(!toggleFlagsState)
                    FlagToggleView(viewModel: FlagToggleView.ViewModel(toggleState: $toggleFlagYellowState, selctedGifName: $hoverFlagName, label: "Single yellow", gifName: "yellow.gif"))
                        .disabled(!toggleFlagsState)
                    FlagToggleView(viewModel: FlagToggleView.ViewModel(toggleState: $toggleFlagRedState, selctedGifName: $hoverFlagName, label: "Red", gifName: "red.gif"))
                        .disabled(!toggleFlagsState)
                    FlagToggleView(viewModel: FlagToggleView.ViewModel(toggleState: $toggleFlagChequeredState, selctedGifName: $hoverFlagName, label: "Chequered", gifName: "chequered.gif"))
                        .disabled(!toggleFlagsState)
                    FlagToggleView(viewModel: FlagToggleView.ViewModel(toggleState: $toggleFlagGreenState, selctedGifName: $hoverFlagName, label: "Green", gifName: "green.gif"))
                        .disabled(!toggleFlagsState)
                    FlagToggleView(viewModel: FlagToggleView.ViewModel(toggleState: $toggleFlagBlueState, selctedGifName: $hoverFlagName, label: "Blue", gifName: "blue.gif"))
                        .disabled(!toggleFlagsState)
                    FlagToggleView(viewModel: FlagToggleView.ViewModel(toggleState: $toggleFlagMeatballState, selctedGifName: $hoverFlagName, label: "Black and Orange flag (meatball)", gifName: "mec.gif"))
                        .disabled(!toggleFlagsState)
                }
                .padding(.leading)
                
                if let flagGifName = $hoverFlagName.wrappedValue {
                    AnimatedImage(name: flagGifName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.bottom)
                    
                    Button {
                        hoverFlagName = nil
                    } label: {
                        Text("close preview")
                    }
                }
            }
            .tabItem {
                Text("Messages")
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Base URL:")
                    TextField("http://...", text: $apiBaseUrl)
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
                SettingsView.SaveSettingsToggle(forKey: "announce.flags", toggleFlagsState)
                SettingsView.SaveSettingsToggle(forKey: "announce.flags.yellow", toggleFlagYellowState)
                SettingsView.SaveSettingsToggle(forKey: "announce.flags.doubleYellow", toggleFlagDoubleYellowState)
                SettingsView.SaveSettingsToggle(forKey: "announce.flags.blue", toggleFlagBlueState)
                SettingsView.SaveSettingsToggle(forKey: "announce.flags.chequered", toggleFlagChequeredState)
                SettingsView.SaveSettingsToggle(forKey: "announce.flags.green", toggleFlagChequeredState)
                SettingsView.SaveSettingsToggle(forKey: "announce.flags.red", toggleFlagChequeredState)
                SettingsView.SaveSettingsToggle(forKey: "announce.flags.meatball", toggleFlagMeatballState)
                
                SettingsView.SaveSettingsToggle(forKey: "announce.deletedLaps", toggleDeletedTimesState)
                SettingsView.SaveSettingsToggle(forKey: "announce.missedApex", toggleMissedApexState)
                SettingsView.SaveSettingsToggle(forKey: "announce.offTrack", toggleOffTrackState)
                SettingsView.SaveSettingsToggle(forKey: "announce.mazespin", toggleSpunState)
                
                UserDefaults.standard.set(apiBaseUrl, forKey: "api.url")
                
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
