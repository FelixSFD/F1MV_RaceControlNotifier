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

struct SettingsNavMessagesView: View {
    @AppStorage(Constants.Settings.Keys.announceDeletedLaps) var toggleDeletedTimesState = UserDefaults.standard.announceDeletedLaps
    @AppStorage(Constants.Settings.Keys.announceMissedApex) var toggleMissedApexState = UserDefaults.standard.announceMissedApex
    @AppStorage(Constants.Settings.Keys.announceOffTrack) var toggleOffTrackState = UserDefaults.standard.announceOffTrack
    @AppStorage(Constants.Settings.Keys.announceSpun) var toggleSpunState = UserDefaults.standard.announceSpun
    
    // TODO: Save settings
    @State var flagToggleItems: [EnumToggleList.ItemModel] = getAvailableFlagItems()
    @AppStorage(Constants.Settings.Keys.announceFlags) var toggleFlagsState = UserDefaults.standard.announceFlags
    
    private static func getAvailableFlagItems() -> [EnumToggleList.ItemModel] {
        FlagColor.allCases.map { flagColor in
            return EnumToggleList.ItemModel(code: flagColor.rawValue, label: flagColor.description, isEnabled: false)
        }
    }
    
    private func saveEnabledFlags() {
        print("saveEnabledFlags()")
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
    }
    
    var body: some View {
        NavigationStack {
            Form {
                SettingsMessagesView(toggleDeletedTimesState: $toggleDeletedTimesState, toggleMissedApexState: $toggleMissedApexState, toggleOffTrackState: $toggleOffTrackState, toggleSpunState: $toggleSpunState, toggleFlagsState: $toggleFlagsState, flagToggleItems: $flagToggleItems)
            }
            .navigationBarTitle("Settings")
        }
        .onChange(of: flagToggleItems) { newValue in
            self.saveEnabledFlags()
        }
    }
}

struct SettingsNavMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsNavMessagesView()
    }
}
