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


struct VoiceSelectionItem: Identifiable, Equatable, Hashable {
    var id: String
    let name: String
    let quality: AVSpeechSynthesisVoiceQuality
    let language: String
    let gender: String
    
    let voiceObject: AVSpeechSynthesisVoice
    
    init(voiceObject: AVSpeechSynthesisVoice) {
        self.id = voiceObject.identifier
        self.name = voiceObject.name
        self.quality = voiceObject.quality
        self.language = voiceObject.language
        self.gender = String(reflecting: voiceObject.gender)
        self.voiceObject = voiceObject
    }
}


struct SettingsNavView: View {
    @AppStorage(Constants.Settings.Keys.apiUrl) private var apiUrl: String = UserDefaults.standard.apiUrl
    @AppStorage(Constants.Settings.Keys.voiceId) private var voiceId: String = UserDefaults.standard.voiceId
    
    private let availableVoices: [VoiceSelectionItem] = SettingsNavView.getVoiceEntries()
    @State private var voiceIndex: Int = 0
    
    
    private static func getVoiceEntries() -> [VoiceSelectionItem] {
        return AVSpeechSynthesisVoice.speechVoices().map { voiceObj in
            return VoiceSelectionItem(voiceObject: voiceObj)
        }
        .sorted(by: { $0.language < $1.language })
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("API URL", text: $apiUrl)
                    //LabeledContent("iOS Version", value: "16.2")
                } header: {
                    Text("API Configuration")
                }
                
                Section {
                    Picker("Voice", selection: $voiceIndex) {
                        ForEach(0 ..< availableVoices.count) {
                            let voice = self.availableVoices[$0]
                            
                            VStack(alignment: .leading) {
                                Text("\(voice.name)")
                                Text(voice.language)
                                    .font(.caption2)
                            }
                        }
                    }
                    .pickerStyle(.navigationLink)

                } header: {
                    Text("Voice")
                }
                
                NavigationLink {
                    SettingsNavMessagesView()
                } label: {
                    Text("Messages")
                }

            }
            .onChange(of: voiceIndex) { newValue in
                self.voiceId = availableVoices[newValue].id
            }
            .onAppear {
                voiceIndex = availableVoices.firstIndex(where: { $0.id == self.voiceId }) ?? 0
            }
            #if os(iOS)
            .navigationBarTitle("Settings")
            #endif
        }
    }
}

struct SettingsNavView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsNavView()
    }
}
