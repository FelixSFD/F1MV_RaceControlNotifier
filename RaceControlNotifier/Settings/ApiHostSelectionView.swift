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
import SwiftUI
import Bonjour
import MultipeerConnectivity


struct ApiHostSelectionView : View {
    struct ViewModel {
        @Binding var selectedPeer: Peer?
    }
    
    @EnvironmentObject var bonjour: DisvoceredDevicesViewModel
    @State var viewModel: ViewModel
    
    var body: some View {
        List(bonjour.discoveredDevices, id: \.self, selection: viewModel.$selectedPeer) { peer in
            Text(peer.name)
            Text(peer.id)
                .font(.caption)
        }
    }
}


struct ApiHostSelectionViewPreviewWrapper: View {
    @State var selectedPeer: Peer?
    var sampleDevices: [Peer] = []
    
    init() {
        for i in 1...5 {
            let device = try! Peer(peer: MCPeerID(displayName: "Sample Device \(i)"), discoveryInfo: nil)
                sampleDevices.append(device)
            
        }
        
        print(sampleDevices)
    }
    
    var body: some View {
        ApiHostSelectionView(viewModel: ApiHostSelectionView.ViewModel(selectedPeer: $selectedPeer))
            .environmentObject({ () -> DisvoceredDevicesViewModel in
                let m =  MockDisvoceredDevicesViewModel(discoveredDevices: sampleDevices)
                m.startDiscovery()
                return m
            }())
    }
}


struct ApiHostSelectionView_Previews: PreviewProvider {
    
    static var previews: some View {
        ApiHostSelectionViewPreviewWrapper()
    }
}
