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
import AVFAudio

typealias ListPickerKeyType = Hashable & Comparable
typealias ListPickerValueType = Hashable

struct ListPickerView<TKey: ListPickerKeyType, ID: Hashable, TValue: ListPickerValueType, LabelContent: View, RowContent: View, HeaderContent: View>: View {
    @State var data: [TKey: [TValue]]
    @Binding var selection: TValue
    
    let id: KeyPath<TValue, ID>
    
    let label: (Binding<TValue>) -> LabelContent
    let row: (TValue, Bool) -> RowContent
    let header: (TKey) -> HeaderContent
    
    
    var navWrapper: some View {
        NavigationLink {
            self.listView
        } label: {
            HStack {
                label($selection)
            }
        }
    }
    
    
    var listView: some View {
        List {
            ForEach(data.sorted(by: { $0.key > $1.key }), id: \.key) { section, items in
                Section(header: header(section)) {
                    ForEach(items, id: \.self) { item in
                        row(item, item == selection)
                            .onTapGesture {
                                selection = item
                            }
                    }
                }
                
            }
        }
    }
    
    
    var body: some View {
        self.navWrapper
    }
}


struct ListPickerView_Previews: PreviewProvider {
    @State static var data = [AVSpeechSynthesisVoiceQuality.default: ["value1", "value2"], AVSpeechSynthesisVoiceQuality.premium: ["value3", "value4"]]
    @State static var selected: String?
    
    
    static var previews: some View {
        ListPickerView(data: data, selection: $selected, id: \.self) {
            selection in
            HStack {
                Text("Voice")
                Spacer()
                Text(selection.wrappedValue ?? "default")
                    .foregroundColor(.secondary)
            }
        } row: { rowItem, selected in
            Text(rowItem ?? "default")
        } header: { headerKey in
            HStack {
                Text(headerKey.description)
                Image(systemName: "gear")
            }
        }
    }
}
