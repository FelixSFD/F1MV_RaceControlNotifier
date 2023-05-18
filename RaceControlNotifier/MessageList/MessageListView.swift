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
    @ObservedObject
    var rcmNotifier: RCMNotifier
    
    @State
    private var messages: [RaceControlMessageModel] = []
    
    
    @ObservedObject
    var tts: TextToSpeech
    
    
    @State
    private var isSpeaking: Bool = false
    
    
    var body: some View {
        List {
            ForEach($rcmNotifier.reversedMessages) { message in
                HStack {
                    Button {
                        tts.say(message.message.wrappedValue, messageId: message.id)
                    } label: {
                        if (tts.currentlySpeaking[message.id] == nil) {
                            Image(systemName: "play")
                        } else {
                            Image(systemName: "stop.fill")
                        }
                    }
                    
                    MessageListItemView(messageText: message.message.wrappedValue, date: message.date.wrappedValue, ttsEnabled: message.ttsEnabled.wrappedValue)
                        .listRowSeparatorTint(.gray)
                }
            }
        }
        .listStyle(.inset(alternatesRowBackgrounds: true))
    }
}

struct MessageListView_Previews: PreviewProvider {
    @State static var sampleMessages = [RaceControlMessageModel(date: Date.now, message: "CAR 63 (RUS) TIME 1:19.376 DELETED - TRACK LIMITS AT TURN 12 LAP 18 15:59:37", category: .other, ttsEnabled: true), RaceControlMessageModel(date: Date.now, message: "CHEQUERED FLAG", category: .flag, ttsEnabled: false)]
    
    private static var notifier = RCMNotifier(fetcher: RCMFetcher(), textToSpeech: TextToSpeech())
    
    static var previews: some View {
        MessageListView(rcmNotifier: notifier, tts: TextToSpeech()
        )
    }
}
