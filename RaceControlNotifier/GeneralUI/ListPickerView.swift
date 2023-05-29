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

typealias ListPickerKeyType = Hashable & Comparable
typealias ListPickerValueType = Hashable

struct ListPickerView<TKey: ListPickerKeyType, ID: Hashable, TValue: ListPickerValueType, RowContent: View, HeaderContent: View>: View {
    @State var data: [TKey: [TValue]]
    @State var selection: TValue?
    
    let id: KeyPath<Data.Element, ID>
    
    let row: (TValue, Bool) -> RowContent
    let header: (TKey) -> HeaderContent
    
    var body: some View {
        List {
            ForEach(data.sorted(by: { $0.key < $1.key }), id: \.key) { section, items in
                Section {
                    ForEach(items, id: \.self) { item in
                       row(item, item == selection)
                    }
                } header: {
                    header(section)
                }

            }
        }
    }
}


struct ListPickerView_Previews: PreviewProvider {
    @State static var data = ["section1": ["value1", "value2"], "section2": ["value3", "value4"]]
    
    
    static var previews: some View {
        ListPickerView(data: data, id: \.self) { rowItem, selected in
            Text(rowItem)
        } header: { headerKey in
            HStack {
                Text(headerKey)
                Image(systemName: "gear")
            }
        }
    }
}
