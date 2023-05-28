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


/// Represents a voice that can be selected
struct SettingsVoiceOptionView: View {
    let voice: VoiceSelectionItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(voice.name)
            Text("\(voice.gender.description) - \(voice.language) - \(voice.quality.rawValue)")
                .font(.caption2)
        }
    }
}

struct SettingsVoiceOptionView_Previews: PreviewProvider {
    static let v = AVSpeechSynthesisVoice()
    
    static var previews: some View {
        SettingsVoiceOptionView(voice: VoiceSelectionItem(id: "de.felixsfd.test.voice", name: "FelixSFD (premium)", quality: .premium, language: "de_BY", gender: AVSpeechSynthesisVoiceGender.male, voiceObject: v))
    }
}
