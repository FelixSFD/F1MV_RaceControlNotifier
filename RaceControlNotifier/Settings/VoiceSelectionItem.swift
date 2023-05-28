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
import AVFAudio


public struct VoiceSelectionItem: Identifiable, Equatable, Hashable {    
    public var id: String
    public let name: String
    public let quality: AVSpeechSynthesisVoiceQuality
    public let language: String
    public let gender: AVSpeechSynthesisVoiceGender
    
    public let voiceObject: AVSpeechSynthesisVoice
    
    public init(voiceObject: AVSpeechSynthesisVoice) {
        self.id = voiceObject.identifier
        self.name = voiceObject.name
        self.quality = voiceObject.quality
        self.language = voiceObject.language
        self.gender = voiceObject.gender
        self.voiceObject = voiceObject
    }
    
    
    public init(id: String, name: String, quality: AVSpeechSynthesisVoiceQuality, language: String, gender: AVSpeechSynthesisVoiceGender, voiceObject: AVSpeechSynthesisVoice) {
        self.id = id
        self.name = name
        self.quality = quality
        self.language = language
        self.gender = gender
        self.voiceObject = voiceObject
    }
}



extension AVSpeechSynthesisVoiceGender: CustomStringConvertible {
    public var description: String {
        switch self {
        case .male:
            return "male"
        case .female:
            return "female"
        default:
            return "other"
        }
    }
}
