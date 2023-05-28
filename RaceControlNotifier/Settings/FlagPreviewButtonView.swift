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

#if os(macOS)
import SDWebImageSwiftUI
#endif

struct FlagPreviewButtonView: View {
    
    let gifName: String
    
    @Binding var selectedGifName: String?
    
    @State var showFlagGif: Bool = false
    
    var body: some View {
        Button {
            selectedGifName = gifName
            showFlagGif = true
        } label: {
            Image(systemName: "eye.circle")
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showFlagGif) {
            VStack {
                #if os(macOS)
                AnimatedImage(name: gifName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.bottom)
                #endif
                
                Button {
                    showFlagGif = false
                } label: {
                    Text("close preview")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
