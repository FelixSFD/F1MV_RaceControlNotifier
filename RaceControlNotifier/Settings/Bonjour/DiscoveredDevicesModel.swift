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
import Bonjour
import MultipeerConnectivity


/// View model for devices discovered by Bonjour
class DisvoceredDevicesViewModel: ObservableObject {
    @Published var isDiscovering: Bool
    
    @Published var discoveredDevices: [Peer]
    
    private let bonjour: BonjourSession = BonjourSession(configuration: BonjourSession.Configuration(serviceType: "MultiViewer",
                                                                                                     peerName: Host.current().name ?? "Unknown Mac with RaceControlNotifier",
                                                                                                     defaults: .standard,
                                                                                                     security: .default,
                                                                                                     invitation: .automatic))
    
    
    init(isDiscovering: Bool = false, discoveredDevices: [Peer] = []) {
        self.isDiscovering = isDiscovering
        self.discoveredDevices = discoveredDevices
        
        bonjour.onAvailablePeersDidChange = {
            peers in
            print("Discovered peers")
            DispatchQueue.main.async {
                self.discoveredDevices = peers
            }
        }
        
        bonjour.onPeerDiscovery = {
            peer in
            print("Discovered peer: \(peer)")
        }

    }
    
    
    func startDiscovery() {
        bonjour.start()
    }
    
    func stopDiscovery() {
        bonjour.stop()
    }
}



class MockDisvoceredDevicesViewModel: DisvoceredDevicesViewModel {
    override init(isDiscovering: Bool = false, discoveredDevices: [Peer] = []) {
        super.init(isDiscovering: false, discoveredDevices: [])
    }
    
    override func startDiscovery() {
        discoveredDevices = (try? [Peer(peer: MCPeerID(displayName: "Sample"), discoveryInfo: nil)]) ?? []
    }
    
    override func stopDiscovery() {
    }
}
