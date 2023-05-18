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

struct MessageListItemView: View {
    @State
    var messageText: String
    
    @State
    var date: Date
    
    
    @State
    var ttsEnabled: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(messageText)
                .fontWeight(.bold)
            
            HStack(alignment: .center) {
                Text(date.formatted())
                    .font(.caption2.italic())
                    .foregroundColor(.gray)
                
                Spacer()
                
                if ttsEnabled {
                    Image(systemName: "speaker.wave.2.circle")
                } else {
                    Image(systemName: "speaker.slash.circle")
                }
            }
        }
        .opacity(ttsEnabled ? 1 : 0.7)
    }
}

struct MessageListItemView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListItemView(messageText: "TEST MESSAGE - RED FLAG", date: Date.now, ttsEnabled: true)
        
        MessageListItemView(messageText: "TEST MESSAGE - BLUE FLAG - NO TTS", date: Date.now, ttsEnabled: false)
    }
}
