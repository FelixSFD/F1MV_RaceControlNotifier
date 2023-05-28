//
// RaceControlNotifier for MultiViewer
// Copyright (c) 2023  FelixSFD
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

struct SettingsMessagesView: View {
    @Binding var toggleDeletedTimesState: Bool
    @Binding var toggleMissedApexState: Bool
    @Binding var toggleOffTrackState: Bool
    @Binding var toggleSpunState: Bool
    @Binding var toggleFlagsState: Bool
    
    @Binding var flagToggleItems: [EnumToggleList.ItemModel]
    
    
    var body: some View {
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
        #if os(macOS)
        .listStyle(.inset)
        #endif
        .toggleStyle(.switch) // set switch-style for everything in the list
    }
}

//struct SettingsFlagListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsMessagesView()
//    }
//}
