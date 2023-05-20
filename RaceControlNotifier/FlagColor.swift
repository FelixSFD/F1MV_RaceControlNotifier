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

import Foundation


/// Flags that can be waved at the track
enum FlagColor : String, Codable, EnumToggleListCompatible {
    var description: String {
        switch (self) {
        case .blue:
            return "Blue"
        case .red:
            return "Red"
        case .blackWhite:
            return "Black and white"
        case .doubleYellow:
            return "Double yellow"
        case .yellow:
            return "Single yellow"
        case .chequered:
            return "Chequered"
        case .green:
            return "Green"
        case .meatball:
            return "Blag and orange (\"meatball\")"
        }
    }
    
    var id: String { rawValue }
    
    case green, yellow, doubleYellow, red, blue, chequered, meatball, blackWhite
}
