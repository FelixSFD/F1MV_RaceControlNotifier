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


struct SettingsNavView: View {
    @AppStorage(Constants.Settings.Keys.apiUrl) private var apiUrl: String = UserDefaults.standard.apiUrl
    @AppStorage(Constants.Settings.Keys.voiceId) private var voiceId: String = UserDefaults.standard.voiceId
    
    private let availableVoices: [AVSpeechSynthesisVoiceQuality: [VoiceSelectionItem]] = SettingsNavView.getVoiceEntries()
    @State private var selectedVoice: VoiceSelectionItem = VoiceSelectionItem(voiceObject: AVSpeechSynthesisVoice())
    
    private let demoTts = TextToSpeech(voiceId: UserDefaults.standard.voiceId)
    @State private var firstVoiceLoad = false;
    
    
    private static func getVoiceEntries() -> [AVSpeechSynthesisVoiceQuality: [VoiceSelectionItem]] {
        return AVSpeechSynthesisVoice.speechVoices()
            .filter({ $0.language.starts(with: "en-") })
            .map { voiceObj in
                return VoiceSelectionItem(voiceObject: voiceObj)
            }
            .sorted(by: { $0.name < $1.name })
            .dictionary(keyPath: \.quality)
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
                    ListPickerView(data: availableVoices, selection: $selectedVoice, id: \.id) { selection in
                        HStack {
                            Text("Voice")
                            Spacer()
                            Text(selection.wrappedValue.name)
                                .foregroundColor(.secondary)
                        }
                    } row: { voice, selected in
                        SettingsVoiceOptionView(voice: voice, selected: selected)
                            .onChange(of: selected) { newValue in
                                if newValue {
                                    demoTts.voice = voice.voiceObject
                                    demoTts.say("This is an important message from the FIA: CAR 44 (HAM) is complaining about the car again")
                                }
                            }
                    } header: { quality in
                        Text("\(quality.description) quality")
                    }
                    .navigationTitle("Select voice")

                    Button {
                        TextToSpeech(voiceId: self.voiceId).say("This is an important message from the FIA: CAR 44 (HAM) is complaining about the car again")
                    } label: {
                        Text("Test voice")
                    }
                } header: {
                    Text("Voice")
                }
                
                NavigationLink {
                    SettingsNavMessagesView()
                } label: {
                    Text("Messages")
                }

            }
            .onChange(of: selectedVoice) { newValue in
                self.voiceId = newValue.id
            }
            .onAppear {
                let flatVoices = availableVoices.values.flatMap({$0})
                guard let setVoice = flatVoices.first(where: { $0.id == self.voiceId }) else {
                    print("NO VOICE FOUND")
                    if !availableVoices.isEmpty {
                        selectedVoice = flatVoices.first!
                    }
                    return
                }
                
                selectedVoice = setVoice
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
