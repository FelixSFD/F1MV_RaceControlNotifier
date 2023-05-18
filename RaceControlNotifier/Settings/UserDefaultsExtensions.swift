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

import Foundation


extension UserDefaults {
    /// Base URL for the F1MV API
    @objc dynamic var apiUrl: String {
        return string(forKey: Constants.Settings.Keys.apiUrl) ?? Constants.Settings.defaultApiUrl
    }
    
    
    /// true, if flags should be announced
    @objc dynamic var announceFlags: Bool {
        return bool(forKey: Constants.Settings.Keys.announceFlags)
    }
    
    
    /// List of flags to announce. (only when announceFlags is true)
    dynamic var announceFlagsEnabled: [FlagColor] {
        return object(forKey: Constants.Settings.Keys.announceFlagsEnabled) as! [FlagColor]
    }
    
    
    /// List of flags to announce. (only when announceFlags is true)
    dynamic var announceFlagsDisabled: [FlagColor] {
        return object(forKey: Constants.Settings.Keys.announceFlagsDisabled) as! [FlagColor]
    }
    
    
    /// true, if deleted laps should be announced
    @objc dynamic var announceDeletedLaps: Bool {
        return bool(forKey: Constants.Settings.Keys.announceDeletedLaps)
    }
    
    
    /// true, if missed apex messages should be announced
    @objc dynamic var announceMissedApex: Bool {
        return bool(forKey: Constants.Settings.Keys.announceMissedApex)
    }
    
    
    /// true, if off-track messages should be announced
    @objc dynamic var announceOffTrack: Bool {
        return bool(forKey: Constants.Settings.Keys.announceOffTrack)
    }
    
    
    /// true, if spinning cars should be announced
    @objc dynamic var announceSpun: Bool {
        return bool(forKey: Constants.Settings.Keys.announceSpun)
    }
}
