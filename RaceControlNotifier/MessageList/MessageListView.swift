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

struct MessageListView: View {
    
    @Binding
    var messages: [RaceControlMessageModel]
    
    
    let tts: TextToSpeech
    
    
    var body: some View {
        List {
            ForEach(messages) { message in
                HStack {
                    Button {
                        tts.say(message.message)
                    } label: {
                        Image(systemName: "play")
                    }
                    
                    MessageListItemView(messageText: message.message, date: message.date)
                        .listRowSeparatorTint(.gray)
                }
            }
        }
        .listStyle(.bordered)
    }
}

struct MessageListView_Previews: PreviewProvider {
    @State static var sampleMessages = [RaceControlMessageModel(date: Date.now, message: "CAR 63 (RUS) TIME 1:19.376 DELETED - TRACK LIMITS AT TURN 12 LAP 18 15:59:37", category: .other), RaceControlMessageModel(date: Date.now, message: "CHEQUERED FLAG", category: .flag)]
    
    static var previews: some View {
        MessageListView(messages: $sampleMessages, tts: TextToSpeech()
        )
    }
}
