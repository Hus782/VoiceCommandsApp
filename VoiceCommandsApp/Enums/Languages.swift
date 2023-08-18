//
//  Languages.swift
//  VoiceCommandsApp
//
//  Created by user240865 on 8/14/23.
//

import Foundation

// An enum used for adding new languages
// Only four have been added for now
enum Languages: String {
    case English = "en"
    case German = "de"
    case Chinese = "zh"
    case french = "fr"
    
    var locale: Locale {
            return Locale(identifier: rawValue)
    }
    
}
