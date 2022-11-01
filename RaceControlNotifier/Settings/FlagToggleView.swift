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

struct FlagToggleView: View {
    struct ViewModel {
        @Binding var toggleState: Bool
        @Binding var selctedGifName: String?
        
        let label: String
        let gifName: String
    }
    
    
    @State var viewModel: ViewModel
    
    
    var body: some View {
        Toggle(isOn: viewModel.$toggleState){
            Text(viewModel.label)
            
            FlagPreviewButtonView(gifName: viewModel.gifName, selectedGifName: viewModel.$selctedGifName)
        }
    }
}

