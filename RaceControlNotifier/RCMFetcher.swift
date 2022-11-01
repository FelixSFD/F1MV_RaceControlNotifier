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


class RCMFetcher {
    enum RequestError: Error {
        case invalidURL
        case missingData
        case mappingError
    }
    
    
    public var apiBaseUrl = UserDefaults.standard.string(forKey: "api.url") ?? "http://localhost:10101"
    
    
    public struct MessageDTO: Codable {
        var date: String
        
        var message: String
        
        var categoryStr: String
        
        var flag: String?
        
        
        func getCategory() -> RaceControlMessageCategory {
            return RaceControlMessageCategory(rawValue: categoryStr) ?? .other
        }
        
        
        func getFlagColor() -> FlagColor? {
            guard let safeFlag = flag else {
                return nil
            }
            
            switch safeFlag.lowercased() {
            case "blue":
                return .blue
            case "yellow":
                return .yellow
            case "double yellow":
                return .doubleYellow
            case "chequered":
                return .chequered
            case "black orange":
                return .meatball
            case "green":
                return .green
            case "clear":
                return .green
            default:
                print("Error parsing flag-color: \(safeFlag)")
                return nil
            }
        }
        
        
        /// Some categories are only distinguishable by message text, not the category in the JSON.
        /// This method tries to fix the category and flag-color
        mutating func fixCategoryAndFlag() {
            let category = getCategory()
            if category == .other {
                if message.localizedCaseInsensitiveContains("OFF TRACK AND CONTINUED") {
                    categoryStr = RaceControlMessageCategory.offTrack.rawValue
                } else if message.localizedCaseInsensitiveContains("MISSED THE APEX") {
                    categoryStr = RaceControlMessageCategory.missedApex.rawValue
                } else if message.localizedCaseInsensitiveContains("SPUN AND CONTINUED") {
                    categoryStr = RaceControlMessageCategory.spun.rawValue
                } else if message.localizedCaseInsensitiveContains("BLACK AND ORANGE FLAG") {
                    categoryStr = RaceControlMessageCategory.flag.rawValue
                    flag = "black orange"
                }
            }
        }
        
        
        private enum CodingKeys : String, CodingKey {
            case date = "Utc", message = "Message", categoryStr = "Category", flag = "Flag"
        }
    }
    
    
    public struct MessagesWrapperDTO: Codable {
        var messages: [MessageDTO]
        
        
        private enum CodingKeys : String, CodingKey {
            case messages = "Messages"
        }
    }
    
    
    func getMessages() async throws -> [RaceControlMessageModel] {
        guard let url = URL(string: "\(apiBaseUrl)/v2/live-timing/state/RaceControlMessages") else { throw RequestError.missingData }
        
        #if DEBUG
        print("URL: \(url)")
        #endif
        
        guard let (data, response) = try? await URLSession.shared.data(from: url) else{throw RequestError.invalidURL}
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {throw RequestError.invalidURL}
        print("request finished")
        print(String(data: data, encoding: .utf8) ?? "failed to parse data to string")
        let decoder = JSONDecoder()
        guard let jsonResponse = try? decoder.decode(MessagesWrapperDTO.self, from: data) else {throw RequestError.mappingError}
        
        let messageDTOs = jsonResponse.messages
        return messageDTOs.map {
            rawDto in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
            let date = dateFormatter.date(from: rawDto.date)
            
            var fixedDto = rawDto
            fixedDto.fixCategoryAndFlag()
            
            return RaceControlMessageModel(date: date ?? Date.distantPast, message: fixedDto.message, category: fixedDto.getCategory(), flag: fixedDto.getFlagColor())
        }
    }
    
    
    func getRandomFakeMessages() throws -> [RaceControlMessageModel] {
        let randomInt = Int.random(in: 40..<50)
        if randomInt != 47 {
            return []
        }
        
        //let json = """
        //{"Messages":[{"Utc":"2022-07-23T11:41:33","Category":"Drs","Message":"DRS DISABLED IN ZONE 2","Flag":"DISABLED"},{"Utc":"2022-07-23T11:41:37","Category":"Flag","Flag":"CLEAR","Scope":"Sector","Sector":2,"Message":"CLEAR IN TRACK SECTOR 2"},{"Utc":"2022-07-23T11:41:37","Category":"Drs","Message":"DRS ENABLED IN ZONE 2","Flag":"ENABLED"},{"Utc":"2022-07-23T11:42:12","Category":"MissedApex","RacingNumber":"44","Message":"CAR 44 (HAM) MISSED THE APEX OF TURN 1"}],"_kf":true}
        //"""
        
//        let json = """
//        {"Messages":[{"Utc":"2022-07-24T12:30:00","Lap":1,"Category":"PitExit","Message":"PIT EXIT CLOSED","Flag":"CLOSED"},{"Utc":"2022-07-24T12:36:21","Lap":1,"Category":"Flag","Flag":"YELLOW","Scope":"Sector","Sector":7,"Message":"YELLOW IN TRACK SECTOR 7"},{"Utc":"2022-07-24T12:36:22","Lap":1,"Category":"Drs","Message":"DRS DISABLED IN ZONE 1","Flag":"DISABLED"},{"Utc":"2022-07-24T12:36:23","Lap":1,"Category":"Drs","Message":"DRS ENABLED IN ZONE 1","Flag":"ENABLED"},{"Utc":"2022-07-24T12:36:23","Lap":1,"Category":"Flag","Flag":"CLEAR","Scope":"Sector","Sector":7,"Message":"CLEAR IN TRACK SECTOR 7"},{"Utc":"2022-07-24T12:36:25","Lap":1,"Category":"Flag","Flag":"DOUBLE YELLOW","Scope":"Sector","Sector":7,"Message":"DOUBLE YELLOW IN TRACK SECTOR 7"},{"Utc":"2022-07-24T12:36:26","Lap":1,"Category":"Drs","Message":"DRS DISABLED IN ZONE 1","Flag":"DISABLED"},{"Utc":"2022-07-24T12:36:28","Lap":1,"Category":"Drs","Message":"DRS ENABLED IN ZONE 1","Flag":"ENABLED"},{"Utc":"2022-07-24T12:36:28","Lap":1,"Category":"Flag","Flag":"CLEAR","Scope":"Sector","Sector":7,"Message":"CLEAR IN TRACK SECTOR 7"},{"Utc":"2022-07-24T12:36:30","Lap":1,"Category":"TrackSurfaceSlippery","Message":"TRACK SURFACE SLIPPERY IN TRACK SECTOR 7"},{"Utc":"2022-07-24T12:36:33","Lap":1,"Category":"Flag","Flag":"CLEAR","Scope":"Sector","Sector":7,"Message":"CLEAR IN TRACK SECTOR 7"},{"Utc":"2022-07-24T12:45:02","Lap":1,"Category":"Weather","Message":"RISK OF RAIN FOR F1 RACE IS 0%"},{"Utc":"2022-07-24T12:57:07","Lap":1,"Category":"Drs","Status":"DISABLED","Message":"DRS DISABLED","Flag":"DISABLED"},{"Utc":"2022-07-24T13:03:41","Lap":1,"Category":"PitExit","Flag":"OPEN","Scope":"Track","Message":"GREEN LIGHT - PIT EXIT OPEN"},{"Utc":"2022-07-24T13:04:43","Lap":1,"Category":"Flag","Flag":"YELLOW","Scope":"Sector","Sector":9,"Message":"YELLOW IN TRACK SECTOR 9"},{"Utc":"2022-07-24T13:04:58","Lap":1,"Category":"Flag","Flag":"CLEAR","Scope":"Sector","Sector":9,"Message":"CLEAR IN TRACK SECTOR 9"},{"Utc":"2022-07-24T13:06:01","Lap":2,"Category":"IncidentNoted","Message":"TURN 8 INCIDENT INVOLVING CARS 22 (TSU) AND 31 (OCO) NOTED - CAUSING A COLLISION"},{"Utc":"2022-07-24T13:07:21","Lap":3,"Category":"Drs","Status":"ENABLED","Message":"DRS ENABLED","Flag":"ENABLED"},{"Utc":"2022-07-24T13:08:13","Lap":3,"Category":"IncidentUnderInvestigation","Message":"FIA STEWARDS: TURN 8 INCIDENT INVOLVING CARS 22 (TSU) AND 31 (OCO) UNDER INVESTIGATION - CAUSING A COLLISION"},{"Utc":"2022-07-24T13:09:03","Lap":4,"Category":"TimePenalty","Message":"FIA STEWARDS: 5 SECOND TIME PENALTY FOR CAR 31 (OCO) - CAUSING A COLLISION"},{"Utc":"2022-07-24T13:12:15","Lap":6,"Category":"LapTimeDeleted","Message":"CAR 11 (PER) TIME 1:39.683 DELETED - TRACK LIMITS AT TURN 3 LAP 5 15:10:42"},{"Utc":"2022-07-24T13:13:26","Lap":6,"Category":"LapTimeDeleted","Message":"CAR 18 (STR) TIME 1:40.451 DELETED - TRACK LIMITS AT TURN 3 LAP 3 15:07:31"},{"Utc":"2022-07-24T13:13:59","Lap":7,"Category":"LapTimeDeleted","Message":"CAR 11 (PER) TIME 1:39.774 DELETED - TRACK LIMITS AT TURN 3 LAP 6 15:12:21"},{"Utc":"2022-07-24T13:18:39","Lap":10,"Category":"LapTimeDeleted","Message":"CAR 1 (VER) TIME 1:39.130 DELETED - TRACK LIMITS AT TURN 6 LAP 9 15:17:24"},{"Utc":"2022-07-24T13:32:55","Lap":18,"Category":"Flag","Flag":"YELLOW","Scope":"Sector","Sector":14,"Message":"YELLOW IN TRACK SECTOR 14"},{"Utc":"2022-07-24T13:32:58","Lap":18,"Category":"Flag","Flag":"DOUBLE YELLOW","Scope":"Sector","Sector":14,"Message":"DOUBLE YELLOW IN TRACK SECTOR 14"},{"Utc":"2022-07-24T13:33:16","Lap":18,"Category":"SafetyCar","Status":"DEPLOYED","Mode":"SAFETY CAR","Message":"SAFETY CAR DEPLOYED"},{"Utc":"2022-07-24T13:37:04","Lap":20,"Category":"SafetyCar","Status":"IN THIS LAP","Mode":"SAFETY CAR","Message":"SAFETY CAR IN THIS LAP"},{"Utc":"2022-07-24T13:37:31","Lap":20,"Category":"Flag","Flag":"CLEAR","Scope":"Sector","Sector":14,"Message":"CLEAR IN TRACK SECTOR 14"},{"Utc":"2022-07-24T13:39:03","Lap":20,"Category":"Flag","Flag":"CLEAR","Scope":"Track","Message":"TRACK CLEAR"},{"Utc":"2022-07-24T13:42:19","Lap":22,"Category":"Flag","Flag":"DOUBLE YELLOW","Scope":"Sector","Sector":14,"Message":"DOUBLE YELLOW IN TRACK SECTOR 14"},{"Utc":"2022-07-24T13:42:22","Lap":22,"Category":"Flag","Flag":"YELLOW","Scope":"Sector","Sector":14,"Message":"YELLOW IN TRACK SECTOR 14"},{"Utc":"2022-07-24T13:42:37","Lap":23,"Category":"Flag","Flag":"CLEAR","Scope":"Sector","Sector":14,"Message":"CLEAR IN TRACK SECTOR 14"},{"Utc":"2022-07-24T13:42:50","Lap":23,"Category":"Drs","Status":"ENABLED","Message":"DRS ENABLED","Flag":"ENABLED"},{"Utc":"2022-07-24T13:43:38","Lap":23,"Category":"IncidentNoted","Message":"PIT LANE INCIDENT INVOLVING CAR 55 (SAI) NOTED - UNSAFE RELEASE"},{"Utc":"2022-07-24T13:43:51","Lap":23,"Category":"IncidentUnderInvestigation","Message":"FIA STEWARDS: PIT LANE INCIDENT INVOLVING CAR 55 (SAI) UNDER INVESTIGATION - UNSAFE RELEASE"},{"Utc":"2022-07-24T13:44:17","Lap":24,"Category":"TimePenalty","Message":"FIA STEWARDS: 5 SECOND TIME PENALTY FOR CAR 55 (SAI) - UNSAFE RELEASE"},{"Utc":"2022-07-24T13:45:05","Lap":24,"Category":"IncidentNoted","Message":"TURN 11 INCIDENT INVOLVING CARS 47 (MSC) AND 24 (ZHO) NOTED - CAUSING A COLLISION"},{"Utc":"2022-07-24T13:45:29","Lap":24,"Category":"IncidentUnderInvestigation","Message":"FIA STEWARDS: TURN 11 INCIDENT INVOLVING CARS 47 (MSC) AND 24 (ZHO) UNDER INVESTIGATION - CAUSING A COLLISION"},{"Utc":"2022-07-24T13:48:35","Lap":26,"Category":"TimePenalty","Message":"FIA STEWARDS: 5 SECOND TIME PENALTY FOR CAR 24 (ZHO) - CAUSING A COLLISION"},{"Utc":"2022-07-24T13:52:40","Lap":29,"Category":"LapTimeDeleted","Message":"CAR 4 (NOR) TIME 1:38.985 DELETED - TRACK LIMITS AT TURN 6 LAP 28 15:51:25"},{"Utc":"2022-07-24T13:53:03","Lap":29,"Category":"MissedApex","RacingNumber":"10","Message":"CAR 10 (GAS) MISSED THE APEX OF TURN 8"},{"Utc":"2022-07-24T13:54:19","Lap":30,"Category":"LapTimeDeleted","Message":"CAR 4 (NOR) TIME 1:39.536 DELETED - TRACK LIMITS AT TURN 6 LAP 29 15:53:04"},{"Utc":"2022-07-24T13:55:46","Lap":31,"Category":"LapTimeDeleted","Message":"CAR 55 (SAI) TIME 1:38.211 DELETED - TRACK LIMITS AT TURN 3 LAP 30 15:54:20"},{"Utc":"2022-07-24T13:58:15","Lap":32,"Category":"OffTrackAndContinued","RacingNumber":"44","Message":"CAR 44 (HAM) OFF TRACK AND CONTINUED AT TURN 2"},{"Utc":"2022-07-24T14:06:34","Lap":37,"Category":"LapTimeDeleted","Message":"CAR 6 (LAT) TIME 1:40.768 DELETED - TRACK LIMITS AT TURN 3 LAP 36 16:04:43"},{"Utc":"2022-07-24T14:07:51","Lap":38,"Category":"Flag","Flag":"BLUE","Scope":"Driver","RacingNumber":"24","Message":"WAVED BLUE FLAG FOR CAR 24 (ZHO) TIMED AT 16:07:50"},{"Utc":"2022-07-24T14:08:02","Lap":38,"Category":"Flag","Flag":"YELLOW","Scope":"Sector","Sector":2,"Message":"YELLOW IN TRACK SECTOR 2"},{"Utc":"2022-07-24T14:08:03","Lap":38,"Category":"Drs","Message":"DRS DISABLED IN ZONE 2","Flag":"DISABLED"},{"Utc":"2022-07-24T14:08:08","Lap":38,"Category":"Drs","Message":"DRS ENABLED IN ZONE 2","Flag":"ENABLED"},{"Utc":"2022-07-24T14:08:08","Lap":38,"Category":"Flag","Flag":"CLEAR","Scope":"Sector","Sector":2,"Message":"CLEAR IN TRACK SECTOR 2"},{"Utc":"2022-07-24T14:08:54","Lap":39,"Category":"IncidentNoted","Message":"TURN 2 INCIDENT INVOLVING CARS 6 (LAT) AND 47 (MSC) NOTED - CAUSING A COLLISION"},{"Utc":"2022-07-24T14:09:24","Lap":39,"Category":"Correction","Message":"CORRECTION: TURN 2 INCIDENT INVOLVING CARS 6 (LAT) AND 20 (MAG) NOTED - CAUSING A COLLISION"},{"Utc":"2022-07-24T14:09:56","Lap":39,"Category":"IncidentUnderInvestigation","Message":"FIA STEWARDS: TURN 2 INCIDENT INVOLVING CARS 6 (LAT) AND 20 (MAG) UNDER INVESTIGATION - CAUSING A COLLISION"},{"Utc":"2022-07-24T14:12:08","Lap":41,"Category":"Flag","Flag":"BLUE","Scope":"Driver","RacingNumber":"24","Message":"WAVED BLUE FLAG FOR CAR 24 (ZHO) TIMED AT 16:12:07"},{"Utc":"2022-07-24T14:14:21","Lap":42,"Category":"Flag","Flag":"BLUE","Scope":"Driver","RacingNumber":"6","Message":"WAVED BLUE FLAG FOR CAR 6 (LAT) TIMED AT 16:14:20"},{"Utc":"2022-07-24T14:14:36","Lap":42,"Category":"Flag","Flag":"BLUE","Scope":"Driver","RacingNumber":"24","Message":"WAVED BLUE FLAG FOR CAR 24 (ZHO) TIMED AT 16:14:36"},{"Utc":"2022-07-24T14:14:37","Lap":42,"Category":"IncidentInvestigationAfterSession","Message":"FIA STEWARDS: TURN 2 INCIDENT INVOLVING CARS 6 (LAT) AND 20 (MAG) WILL BE INVESTIGATED AFTER THE RACE - CAUSING A COLLISION"},{"Utc":"2022-07-24T14:14:46","Lap":42,"Category":"Flag","Flag":"BLUE","Scope":"Driver","RacingNumber":"24","Message":"WAVED BLUE FLAG FOR CAR 24 (ZHO) TIMED AT 16:14:45"},{"Utc":"2022-07-24T14:17:44","Lap":44,"Category":"IncidentNoted","Message":"TURN 8 INCIDENT INVOLVING CARS 11 (PER) AND 63 (RUS) NOTED - CAUSING A COLLISION"},{"Utc":"2022-07-24T14:19:23","Lap":45,"Category":"IncidentNoFurtherInvestigation","Message":"FIA STEWARDS: TURN 8 INCIDENT INVOLVING CARS 11 (PER) AND 63 (RUS) REVIEWED NO FURTHER INVESTIGATION - CAUSING A COLLISION"},{"Utc":"2022-07-24T14:20:01","Lap":45,"Category":"LapTimeDeleted","Message":"CAR 23 (ALB) TIME 1:39.638 DELETED - TRACK LIMITS AT TURN 3 LAP 44 16:17:59"},{"Utc":"2022-07-24T14:20:13","Lap":46,"Category":"LapTimeDeleted","Message":"CAR 10 (GAS) TIME 1:39.541 DELETED - TRACK LIMITS AT TURN 3 LAP 44 16:18:00"},{"Utc":"2022-07-24T14:26:05","Lap":49,"Category":"Flag","Flag":"YELLOW","Scope":"Sector","Sector":6,"Message":"YELLOW IN TRACK SECTOR 6"},{"Utc":"2022-07-24T14:26:13","Lap":49,"Category":"Flag","Flag":"YELLOW","Scope":"Sector","Sector":5,"Message":"YELLOW IN TRACK SECTOR 5"},{"Utc":"2022-07-24T14:26:48","Lap":50,"Category":"VirtualSafetyCar","Status":"DEPLOYED","Mode":"VIRTUAL SAFETY CAR","Message":"VIRTUAL SAFETY CAR DEPLOYED"},{"Utc":"2022-07-24T14:27:46","Lap":50,"Category":"VirtualSafetyCar","Status":"ENDING","Mode":"VIRTUAL SAFETY CAR","Message":"VIRTUAL SAFETY CAR ENDING"},{"Utc":"2022-07-24T14:28:30","Lap":50,"Category":"VirtualSafetyCar","Status":"ENDING","Mode":"VIRTUAL SAFETY CAR","Message":"VIRTUAL SAFETY CAR ENDING"},{"Utc":"2022-07-24T14:28:45","Lap":50,"Category":"Flag","Flag":"CLEAR","Scope":"Track","Message":"TRACK CLEAR"},{"Utc":"2022-07-24T14:28:45","Lap":50,"Category":"Flag","Flag":"CLEAR","Scope":"Sector","Sector":5,"Message":"CLEAR IN TRACK SECTOR 5"},{"Utc":"2022-07-24T14:28:45","Lap":50,"Category":"Flag","Flag":"CLEAR","Scope":"Sector","Sector":6,"Message":"CLEAR IN TRACK SECTOR 6"},{"Utc":"2022-07-24T14:28:47","Lap":51,"Category":"Drs","Status":"ENABLED","Message":"DRS ENABLED","Flag":"ENABLED"},{"Utc":"2022-07-24T14:33:41","Lap":53,"Category":"Flag","Flag":"CHEQUERED","Scope":"Track","Message":"CHEQUERED FLAG"}],"_kf":true}
//        """
        
        let json = """
{"Messages":[{"Utc":"2022-07-23T10:51:44","Category":"Other","Message":"BLUE HEAD PADDING MATERIAL MUST BE USED"},{"Utc":"2022-07-23T11:00:00","Category":"PitExit","Flag":"OPEN","Scope":"Track","Message":"GREEN LIGHT - PIT EXIT OPEN"},{"Utc":"2022-07-23T11:09:07","Category":"OffTrackAndContinued","RacingNumber":"20","Message":"CAR 20 (MAG) OFF TRACK AND CONTINUED AT TURN 11"},{"Utc":"2022-07-23T11:22:07","Category":"OffTrackAndContinued","RacingNumber":"16","Message":"CAR 16 (LEC) OFF TRACK AND CONTINUED AT TURN 12"},{"Utc":"2022-07-23T11:23:38","Category":"OffTrackAndContinued","RacingNumber":"11","Message":"CAR 11 (PER) OFF TRACK AND CONTINUED AT TURN 11"},{"Utc":"2022-07-23T11:23:59","Category":"OffTrackAndContinued","RacingNumber":"4","Message":"CAR 4 (NOR) OFF TRACK AND CONTINUED AT TURN 3"},{"Utc":"2022-07-23T11:25:23","Category":"OffTrackAndContinued","RacingNumber":"55","Message":"CAR 55 (SAI) OFF TRACK AND CONTINUED AT TURN 11"},{"Utc":"2022-07-23T11:32:09","Category":"OffTrackAndContinued","RacingNumber":"23","Message":"CAR 23 (ALB) OFF TRACK AND CONTINUED AT TURN 3"},{"Utc":"2022-07-23T11:33:56","Category":"OffTrackAndContinued","RacingNumber":"11","Message":"CAR 11 (PER) OFF TRACK AND CONTINUED AT TURN 3"},{"Utc":"2022-07-23T11:35:03","Category":"OffTrackAndContinued","RacingNumber":"11","Message":"CAR 11 (PER) OFF TRACK AND CONTINUED AT TURN 3"},{"Utc":"2022-07-23T11:41:32","Category":"Flag","Flag":"YELLOW","Scope":"Sector","Sector":2,"Message":"YELLOW IN TRACK SECTOR 2"},{"Utc":"2022-07-23T11:41:33","Category":"Drs","Message":"DRS DISABLED IN ZONE 2","Flag":"DISABLED"},{"Utc":"2022-07-23T11:41:37","Category":"Flag","Flag":"CLEAR","Scope":"Sector","Sector":2,"Message":"CLEAR IN TRACK SECTOR 2"},{"Utc":"2022-07-23T11:41:37","Category":"Drs","Message":"DRS ENABLED IN ZONE 2","Flag":"ENABLED"},{"Utc":"2022-07-23T11:42:12","Category":"MissedApex","RacingNumber":"44","Message":"CAR 44 (HAM) MISSED THE APEX OF TURN 1"},{"Utc":"2022-07-23T14:19:19","Category":"LapTimeDeleted","Message":"CAR 47 (MSC) TIME 1:33.114 DELETED - TRACK LIMITS AT TURN 3 LAP 9 16:17:42"}],"_kf":true}
"""
        let decoder = JSONDecoder()
        
        try decoder.decode(MessagesWrapperDTO.self, from: json.data(using: .utf8)!)
        
        guard let jsonResponse = try? decoder.decode(MessagesWrapperDTO.self, from: json.data(using: .utf8)!) else {throw RequestError.mappingError}
        
        let messageDTOs = jsonResponse.messages
        let mappedMsgs = messageDTOs.map {
            dto -> RaceControlMessageModel in
            
            let date = try? Date(dto.date, strategy: .dateTime)
            return RaceControlMessageModel(date: date ?? Date.distantPast, message: dto.message, category: dto.getCategory(), flag: dto.getFlagColor())
        }
        
        var randomElement = mappedMsgs.randomElement()!
        randomElement.date = Date.now.addingTimeInterval(-2)
        return [randomElement]
    }
}

