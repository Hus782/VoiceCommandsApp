//
//  SpeechViewModel.swift
//  VoiceCommandsApp
//
//  Created by user240865 on 8/14/23.
//

import SwiftUI

protocol SpeechRecognizerDelegate: AnyObject {
    func didUpdateTranscript(_ transcript: String, isImporting: Bool)
}

final class SpeechViewModel: ObservableObject {
    private let speechRecognizer: SpeechRecognizerProtocol
    @Published var isRecording = false
    @Published var appState: AppState = .listeningToCommand
    @Published var currentCommand: CommandModel = CommandModel()
    @Published var commands: [CommandModel] = []
    @Published var transcript = ""
    @Published var importing = false
    @Published var processingData = false

    init(speechRecognizer: SpeechRecognizerProtocol = SpeechRecognizer()) {
        self.speechRecognizer = speechRecognizer
        speechRecognizer.delegate = self
    }
    
    
    func clearData() {
        commands = []
        currentCommand = CommandModel(code: nil, value: "")
        appState = .listeningToCommand
        transcript = ""
        isRecording = false
    }
    
    func startImporting() {
        importing = true
    }
    
    func toggleRecording() {
        if !isRecording {
            startSpeechRecognition()
        } else {
            stopSpeechRecognition()
        }
        isRecording.toggle()
    }
    
    func transcribeFile(url: URL) {
        processingData = true
        speechRecognizer.transcribeAudio(url: url)
    }
    
    private func startSpeechRecognition() {
        speechRecognizer.transcribe()
    }
    
    private func stopSpeechRecognition() {
        speechRecognizer.stopTranscribing()
        appState = .listeningToCommand
        switch currentCommand.code {
//            If stop is pressed and a command is in the pipeline just append it to commands list
        case .code, .count:
            commands.append(CommandModel(code: currentCommand.code, value: currentCommand.value))
            currentCommand = CommandModel(code: nil, value: "")
        default:
            break
        }
    }
    
    private func processTranscript(_ transcript: String) {
        let transcriptSpelled = transcript.convertDigitsToSpelledOut()
        let recognizedWords = transcriptSpelled.lowercased().split(separator: " ").map { String($0) }
        for word in recognizedWords {
            let command = Commands(rawValue: word)
            switch command {
            case .code, .count:
                if appState == .listeningToParameters {
                    commands.append(CommandModel(code: currentCommand.code, value: currentCommand.value))
                } else {
                    appState = .listeningToParameters
                }
                currentCommand = CommandModel(code: command, value: "")
            case .back:
                currentCommand = CommandModel(code: command, value: "")
                commands.popLast()
                appState = .listeningToCommand
            case .reset:
                if appState == .listeningToParameters {
                    currentCommand = CommandModel(code: command, value: "")
                    appState = .listeningToCommand
                }
//          Default case where word is either a digit or some invalid input
            default:
                if let digitValue = digitValue(from: word) {
                    currentCommand = CommandModel(code: currentCommand.code, value: currentCommand.value + digitValue)
                } else {
//                    Might be a good idea to add better handling here. Maybe even show a visual cue
                    print("Invalid word \(word)")
                }
            }
        }
    }
    
    private func digitValue(from word: String) -> String? {
//      Have not added these to the localication files,
//      Each word should be translated to each supported language
        let digitWords = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
        
        if let index = digitWords.firstIndex(of: word.lowercased()) {
            return String(index)
        }
        
        return nil
    }
}

extension SpeechViewModel: SpeechRecognizerDelegate {
    func didUpdateTranscript(_ transcript: String, isImporting: Bool = false) {
        self.transcript = transcript.convertDigitsToSpelledOut()
        processTranscript(transcript)
        if isImporting {
            processingData = false
            stopSpeechRecognition()
        }
    }
}
