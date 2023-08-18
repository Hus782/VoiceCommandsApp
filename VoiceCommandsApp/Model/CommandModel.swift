//
//  CommandModel.swift
//  VoiceCommandsApp
//
//  Created by user240865 on 8/18/23.
//

import Foundation

struct CommandModel: Identifiable, Hashable {
    let id = UUID()
    let code: Commands?
    let value: String
    
    init(code: Commands? = nil, value: String = "") {
        self.code = code
        self.value = value
    }
}
