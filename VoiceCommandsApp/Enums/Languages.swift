//
//  Languages.swift
//  VoiceCommandsApp
//
//  Created by user240865 on 8/14/23.
//

import Foundation

enum Languages: String {
    case English = "en"
    case German = "de"
    case Chinese = "zh"
    case french = "fr"
    
    var locale: Locale {
            return Locale(identifier: rawValue)
    }
    
}
