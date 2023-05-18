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

struct MessageDetailsView: View {
    @State
    var message: RaceControlMessageModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(message.message)
                .fontWeight(.bold)
            
            VStack {
                HStack {
                    Text("Category:")
                    Spacer()
                    Text(message.category.rawValue)
                }
                
                HStack {
                    Text("Date:")
                    Spacer()
                    Text(message.date.ISO8601Format(.iso8601))
                }
                
                if message.category == .flag && message.flag != nil {
                    HStack {
                        Text("Flag color:")
                        Spacer()
                        Text(String(reflecting: message.flag!))
                    }
                }
            }
        }
    }
}

struct MessageDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MessageDetailsView(message: RaceControlMessageModel(date: Date.now, message: "TEST MESSAGE - SAFETY CAR DEPLOYED", category: .other, ttsEnabled: true))
        
        MessageDetailsView(message: RaceControlMessageModel(date: Date.now, message: "TEST MESSAGE - RED FLAG", category: .flag, flag: .red, ttsEnabled: true))
        
        MessageDetailsView(message: RaceControlMessageModel(date: Date.now, message: "TEST MESSAGE - BLUE FLAG FOR MAZESPIN", category: .flag, flag: .blue, ttsEnabled: false))
    }
}
