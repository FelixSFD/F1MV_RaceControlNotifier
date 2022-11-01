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

struct MenuBarListView: View {
    @Environment (\.openWindow) private var openWindow
    
    
    var body: some View {
        Button {
            openWindow(id: "all_messages.window")
        } label: {
            Text("View messages")
        }
        
        Button {
            openWindow(id: "settings.window")
        } label: {
            Text("Settings")
        }
        
        Button {
            NSApplication.shared.terminate(nil)
        } label: {
            Text("Close")
        }
    }
}

struct MenuBarListView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarListView()
    }
}
