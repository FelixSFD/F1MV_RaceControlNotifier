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


typealias EnumToggleListCompatible = CaseIterable & Identifiable & CustomStringConvertible & Equatable

struct EnumToggleList : View {
    struct ItemModel: Identifiable, Equatable {
        var id: String { self.code }
        
        let code: String
        let label: String
        var isEnabled: Bool
    }
    
    
    @Binding
    var items: [ItemModel]
    
    @Binding
    var allWriteable: Bool
    
    
    var body: some View {
        ForEach(self.items.indices) {
            modelIndex in
            Toggle(isOn: $items[modelIndex].isEnabled) {
                Text(self.items[modelIndex].label)
            }
            .toggleStyle(.switch)
            .disabled(!$allWriteable.wrappedValue)
        }
    }
}


struct EnumToggleListPreviewContainer : View {
    @State
    private var items = [
        EnumToggleList.ItemModel(code: "red", label: "Red", isEnabled: true),
        EnumToggleList.ItemModel(code: "blue", label: "Blue", isEnabled: false),
        EnumToggleList.ItemModel(code: "meatball", label: "Black and orange (meatball)", isEnabled: true)
    ]
    
    
    @State var allReadonly: Bool
    
    var body: some View {
        EnumToggleList(items: $items, allWriteable: $allReadonly)
    }
}

struct EnumToggleList_Previews: PreviewProvider {
    static var previews: some View {
        List {
            EnumToggleListPreviewContainer(allReadonly: false)
            EnumToggleListPreviewContainer(allReadonly: true)
        }
    }
}
