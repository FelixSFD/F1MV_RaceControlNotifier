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

/// Constants used in the application
struct Constants {
    /// Constants for the settings (like keys for UserDefaults
    struct Settings {
        /// Keys for the UserDefaults
        struct Keys {
            static let apiUrl = "API_URL" // api.url
            
            static let announceFlags = "ANNOUNCE_FLAGS" // announce.flags
            
            /// Key for the value where the list of enabled flags is stored
            static let announceFlagsEnabled = "ANNOUNCE_FLAGS_ENABLED"
            
            /// Key for the value where the list of disabled flags is stored
            static let announceFlagsDisabled = "ANNOUNCE_FLAGS_DISABLED"
            
            static let announceDeletedLaps = "ANNOUNCE_DELETED_LAPS" // announce.deletedLaps
            
            static let announceMissedApex = "ANNOUNCE_MISSED_APEX" // announce.missedApex
            
            static let announceOffTrack = "ANNOUNCE_OFF_TRACK" // announce.offTrack
            
            static let announceSpun = "ANNOUNCE_MAZESPIN" // announce.mazespin
            
            /// Key for the ID of the selected audio device
            static let selectedOutputDevice = "AUDIO_OUTPUT_DEVICE_ID"
        }
        
        /// Default value for the settings key apiUrl
        static let defaultApiUrl = "http://localhost:10101/api"
    }
}
