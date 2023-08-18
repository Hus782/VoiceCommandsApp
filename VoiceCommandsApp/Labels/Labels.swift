//
//  Labels.swift
//  VoiceCommandsApp
//
//  Created by user240865 on 8/17/23.
//

import Foundation

// All labels used in the app
// This setup allows for an easy localization of the app and addition of multple languages
struct Labels {
    static let commandCode: String = String(localized: "current_command_code")
    static let commandValue: String = String(localized: "current_command_value")
    static let currentStatus: String = String(localized: "current_status")
    static let recordButtonStart: String = String(localized: "record_button_start")
    static let recordButtonStop: String = String(localized: "record_button_stop")
    static let commandsListHeader: String = String(localized: "commands_list_header")
    static let appStateTitle: String = String(localized: "app_state")
    static let detectedSpeechTitle: String = String(localized: "detected_speech")
    static let waitingForCommandState: String = String(localized: "waiting_for_commands_state")
    static let waitingForParametersState: String = String(localized: "waiting_for_parameters_state")
    static let clearButtonTitle: String = String(localized: "clear_button")
    static let importButtonTitle: String = String(localized: "import_button")

}
