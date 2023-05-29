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
    @EnvironmentObject
    var rcmNotifier: RCMNotifier
    
    @State
    private var messages: [RaceControlMessageModel] = []
    
    
    @EnvironmentObject var tts: TextToSpeech
    
    
    #if os(macOS)
    @EnvironmentObject var sca: ObservableSCA
    #endif
    
    
    @State
    private var isSpeaking: Bool = false
    
    
    @State
    private var showingMessageDetail: RaceControlMessageModel? = nil
    
    @State private var showingConnectionErrorSheet: Bool = false
    
    
    var body: some View {
//        let outputDevice = sca.devices.first(where: { $0.isDefaultOutputDevice })
//        if outputDevice != nil {
//            Text("Output to: \(outputDevice!.name)")
//        } else {
//            Text("no device selected")
//        }
        
        List {
            ForEach($rcmNotifier.reversedMessages) { message in
                HStack {
                    Button {
                        tts.say(message.message.wrappedValue, messageId: message.id)
                    } label: {
                        let symbolName = tts.currentlySpeaking[message.id] == nil ? "play" : "stop.fill"
                        
                        Image(systemName: symbolName)
                            .frame(width: 15)
                    }
                    .disabled(tts.currentlySpeaking[message.id] != nil)
                    
                    MessageListItemView(messageText: message.message.wrappedValue, date: message.date.wrappedValue, ttsEnabled: message.ttsEnabled.wrappedValue)
                        .listRowSeparatorTint(.gray)
                        .contextMenu {
                            Button("Details") {
                                print("Should display sheet now")
                                showingMessageDetail = message.wrappedValue
                            }
                        }
                }
            }
        }
        .toolbar(content: {
            if !tts.currentlySpeaking.isEmpty {
                Button {
                    tts.stopEverything(at: .word)
                } label: {
                    Image(systemName: "stop.circle")
                        .foregroundColor(Color.accentColor)
                }
            }
            
            #if os(macOS)
            if rcmNotifier.status == .error {
                Button {
                    showingConnectionErrorSheet = true
                } label: {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(Color.accentColor)
                }
            } else {
                // Workaround to always expand navbar on macOS
                Spacer()
            }
            #endif
        })
#if os(macOS)
        .listStyle(.inset(alternatesRowBackgrounds: true))
        .navigationSubtitle("Powered by MultiViewer")
        .sheet(isPresented: $showingConnectionErrorSheet) {
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .padding()
                Text("Could not fetch messages from Race Control. Please check your connection to MultiViewer.")
                
                Button("Close") {
                    showingConnectionErrorSheet = false
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
#endif
        .sheet(item: $showingMessageDetail) {
            msgItem in
            VStack {
                MessageDetailsView(message: msgItem)
                Button("Close") {
                    showingMessageDetail = nil
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle(Text("Messages"))
    }
}

struct MessageListView_Previews: PreviewProvider {
    @State static var sampleMessages = [RaceControlMessageModel(date: Date.now, message: "CAR 63 (RUS) TIME 1:19.376 DELETED - TRACK LIMITS AT TURN 12 LAP 18 15:59:37", category: .other, ttsEnabled: true), RaceControlMessageModel(date: Date.now, message: "CHEQUERED FLAG", category: .flag, ttsEnabled: false)]
    
    private static var notifier = RCMNotifier(fetcher: RCMFetcher(), textToSpeech: TextToSpeech())
    
    static var previews: some View {
        MessageListView()
            .environmentObject(notifier)
    }
}
