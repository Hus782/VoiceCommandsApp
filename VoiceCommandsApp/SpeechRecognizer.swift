//
//  SpeechRecognizer.swift
//  VoiceCommandsApp
//
//  Created by user240865 on 8/12/23.
//

import Foundation
import AVFoundation
import Foundation
import Speech
import SwiftUI

// Protocol used for mocking when writing unit tests
protocol SpeechRecognizerProtocol: AnyObject {
    func transcribe()
    func stopTranscribing()
    func transcribeAudio(url: URL)
    var delegate: SpeechRecognizerDelegate? { set get }
}

//A helper for transcribing speech to text using SFSpeechRecognizer and AVAudioEngine.
final class SpeechRecognizer: ObservableObject, SpeechRecognizerProtocol {
    
    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let recognizer: SFSpeechRecognizer?
    weak var delegate: SpeechRecognizerDelegate?
//    private let mockTranscription = "Code two three four Count sixty two Code one two Reset Code one one two Count five"
    
//    Default language is English
//    Extra languages not implemented yet in UI
    init(language: Languages = .English) {
        recognizer = SFSpeechRecognizer(locale: language.locale)
            
            Task(priority: .background) {
                do {
                    guard recognizer != nil else {
                        throw RecognizerError.nilRecognizer
                    }
                    guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                        throw RecognizerError.notAuthorizedToRecognize
                    }
                    guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                        throw RecognizerError.notPermittedToRecord
                    }
                } catch {
                    speakError(error)
                }
            }
        }
        
        deinit {
            reset()
        }
    // Reset the speech recognizer.
        private func reset() {
            task?.cancel()
            audioEngine?.stop()
            audioEngine = nil
            request = nil
            task = nil
        }
    
       func transcribe() {
//           Mock transciption for testing
//           speak(mockTranscription)
           DispatchQueue(label: "Speech Recognizer Queue", qos: .background).async { [weak self] in
               guard let self = self, let recognizer = self.recognizer, recognizer.isAvailable else {
                   self?.speakError(RecognizerError.recognizerIsUnavailable)
                   return
               }

               do {
                   let (audioEngine, request) = try Self.prepareEngine()
                   self.audioEngine = audioEngine
                   self.request = request

                   self.task = recognizer.recognitionTask(with: request) { result, error in
                       let receivedFinalResult = result?.isFinal ?? false
                       let receivedError = error != nil // != nil mean there's error (true)

                       if receivedFinalResult || receivedError {
                           audioEngine.stop()
                           audioEngine.inputNode.removeTap(onBus: 0)
                       }

                       if let result = result {
                           self.speak(result.bestTranscription.formattedString)
                       }
                   }
               } catch {
                   self.reset()
                   self.speakError(error)
               }
           }
       }
       
    func transcribeAudio(url: URL) {
        guard let recognizer = self.recognizer, recognizer.isAvailable else {
            speakError(RecognizerError.recognizerIsUnavailable, isImporting: true)
            return
        }
        
        let request = SFSpeechURLRecognitionRequest(url: url)

        // start recognition
        recognizer.recognitionTask(with: request) { [unowned self] (result, error) in
            // abort if we didn't get any transcription back
            guard let result = result else {
                print("There was an error: \(error!)")
                return
            }

            // if we got the final transcription back, print it
            if result.isFinal {
                // pull out the best transcription...
                print(result.bestTranscription.formattedString)
                speak(result.bestTranscription.formattedString, isImporting: true)
            }
        }
    }
    
       private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
           let audioEngine = AVAudioEngine()
           
           let request = SFSpeechAudioBufferRecognitionRequest()
           request.shouldReportPartialResults = true
           
           let audioSession = AVAudioSession.sharedInstance()
           try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
           try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
           let inputNode = audioEngine.inputNode
           
           let recordingFormat = inputNode.outputFormat(forBus: 0)
           inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
               (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
               request.append(buffer)
           }
           audioEngine.prepare()
           try audioEngine.start()
           
           return (audioEngine, request)
       }
    
    // Stop transcribing audio.
    func stopTranscribing() {
            reset()
    }
    
    private func speak(_ message: String, isImporting: Bool = false) {
        delegate?.didUpdateTranscript(message, isImporting: isImporting)
    }
    
    private func speakError(_ error: Error, isImporting: Bool = false) {
            var errorMessage = ""
            if let error = error as? RecognizerError {
                errorMessage += error.message
            } else {
                errorMessage += error.localizedDescription
            }
        delegate?.didUpdateTranscript(errorMessage, isImporting: isImporting)
    }
}

extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}
