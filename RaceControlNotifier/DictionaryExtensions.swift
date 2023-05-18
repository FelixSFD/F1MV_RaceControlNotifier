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


/// Extensions for the dictionary
extension Dictionary where Value: Equatable {
    /// Finds the key for a value
    /// Source: https://stackoverflow.com/a/41386238/4687348
    func getFirstKeyForValue(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
