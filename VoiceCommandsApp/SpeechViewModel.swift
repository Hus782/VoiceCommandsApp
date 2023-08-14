//
//  SpeechViewModel.swift
//  VoiceCommandsApp
//
//  Created by user240865 on 8/14/23.
//

import SwiftUI

protocol SpeechRecognizerDelegate: AnyObject {
    func didUpdateTranscript(_ transcript: String)
}

final class SpeechViewModel: ObservableObject {
    private let speechRecognizer: SpeechRecognizerProtocol
    @Published var isRecording = false
    @Published var appState: AppState = .listeningToCommand
    @Published var currentCommand: Command = Command()
    @Published var commands: [Command] = []
    @Published var transcript = "..."
    
    init(speechRecognizer: SpeechRecognizerProtocol = SpeechRecognizer()) {
        self.speechRecognizer = speechRecognizer
        speechRecognizer.delegate = self
    }
    
    func toggleRecording() {
        if !isRecording {
            startSpeechRecognition()
        } else {
            stopSpeechRecognition()
        }
        isRecording.toggle()
    }
    
    private func startSpeechRecognition() {
        speechRecognizer.transcribe()
    }
    
    private func stopSpeechRecognition() {
        speechRecognizer.stopTranscribing()
    }
    
    func processTranscript(_ transcript: String) {
        // Simulated speech recognition logic
        let recognizedWords = transcript.lowercased().split(separator: " ").map { String($0) }
        
        for word in recognizedWords {
            switch Commands(rawValue: word) {
            case .code, .count:
                if appState == .listeningToParameters {
                    commands.append(Command(code: currentCommand.code, value: currentCommand.value))
                } else {
                    appState = .listeningToParameters
                }
                currentCommand = Command(code: word, value: "")
            case .back:
                if appState == .listeningToCommand {
                    currentCommand = Command(code: word, value: "")
                    commands.popLast()
                }
            case .reset:
                if appState == .listeningToParameters {
                    currentCommand = Command(code: "", value: "")
                }
            default:
                if let digitValue = digitValue(from: word) {
                    currentCommand = Command(code: currentCommand.code, value: currentCommand.value + digitValue)
                } else {
                    print("Invalid word \(word)")
                }
            }
        }
    }
    
    func digitValue(from word: String) -> String? {
        let digitWords = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
        
        if let index = digitWords.firstIndex(of: word.lowercased()) {
            return String(index)
        }
        
        return nil
    }
}

extension SpeechViewModel: SpeechRecognizerDelegate {
    func didUpdateTranscript(_ transcript: String) {
        self.transcript = transcript
        processTranscript(transcript)
    }
}
