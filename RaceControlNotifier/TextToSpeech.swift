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

import Foundation
import Speech


class TextToSpeech {
    private let voice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.premium.en-GB.Malcolm")
    
    
    private let synthesizer = AVSpeechSynthesizer()
    
    
    private let shortcutToDriver: [String: String] = [
        "ALB": "Albon",
        "ALO": "Alonso",
        "BOT": "Bottas",
        "FIT": "Fittipaldi",
        "GAS": "Gasly",
        "GIO": "Giovinazzi",
        "HAM": "Hamilton",
        "LAT": "Latifi",
        "LEC": "Leclerc",
        "MAG": "Magnussen",
        "NOR": "Norris",
        "OCO": "Ocon",
        "PER": "Perez",
        "RIC": "Ricciardo",
        "RUS": "Russell",
        "SAI": "Sainz",
        "MSC": "Schumacher",
        "STR": "Stroll",
        "TSU": "Tsunoda",
        "VER": "Verstappen",
        "VET": "Vettel",
        "ZHO": "Zhou"
    ]
    
    
    private func replaceDriver(_ input: String) -> String {
        var result = input
        shortcutToDriver.forEach {
            mapping in
            result = result.replacingOccurrences(of: "(\(mapping.key))", with: "(\(mapping.value))")
        }
        
        return result
    }
    
    
    private func fixShortcuts(_ input: String) -> String {
        var result = input
        result = result.replacingOccurrences(of: "DRS", with: "D. R. S.")
        result = fixFiaAbbrv(input)
        return result
    }
    
    
    private func fixFiaAbbrv(_ input: String) -> String {
        let pattern = #"\bFIA\b"#
        let regex = try! NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
        let stringRange = NSRange(location: 0, length: input.utf8.count)
        let substitutionString = #"F. I. A."#
        let result = regex.stringByReplacingMatches(in: input, range: stringRange, withTemplate: substitutionString)
        return result
    }
    
    
    private func fixLapTimes(_ input: String) -> String {
        let pattern = #"\b(?<tMin>\d+):(?<tSec>\d{2}).(?<tMilli1>\d)(?<tMilli2>\d)(?<tMilli3>\d)\b"#
        let regex = try! NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
        let stringRange = NSRange(location: 0, length: input.utf8.count)
        let substitutionString = #"$1:$2 point $3 $4 $5"#
        let result = regex.stringByReplacingMatches(in: input, range: stringRange, withTemplate: substitutionString)
        return result
    }
    
    
    private func fixTimestamps(_ input: String) -> String {
        let pattern = #"\b(?<hours>\d{2}):(?<minutes>\d{2}):(?<seconds>\d{2})\b"#
        let regex = try! NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
        let stringRange = NSRange(location: 0, length: input.utf8.count)
        let substitutionString = #"at $1:$2 and $3 seconds"#
        let result = regex.stringByReplacingMatches(in: input, range: stringRange, withTemplate: substitutionString)
        return result
    }
    
    
    func say(_ text: String) {
        var fixedText = replaceDriver(text)
        fixedText = fixShortcuts(fixedText)
        fixedText = fixLapTimes(fixedText)
        fixedText = fixTimestamps(fixedText)
        
        let utterance = AVSpeechUtterance(string: fixedText)
        
        // Configure the utterance.
        utterance.rate = 0.52
        utterance.pitchMultiplier = 0.9
        //utterance.postUtteranceDelay = 0.2
        //utterance.volume = 0.8

        // Assign the voice to the utterance.
        utterance.voice = voice
        
        print("Will speak: \(fixedText)")
        synthesizer.speak(utterance)
    }
}
