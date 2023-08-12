//
//  ContentView.swift
//  VoiceCommandsApp
//
//  Created by user240865 on 8/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        VStack {
         
            List {
                Section{
                    CardView(text: "Status")
                    CardView(text: "Current")
                }
                Section(header: Text("Values")) {
                    CardView(text: "Testing")
                    CardView(text: "Testing")
                    CardView(text: "Testing")
                }
               }
            Button("Button title") {
                print("Button tapped!")
            }
            
        }
//        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}

struct CardView: View {
    let text: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white)
//                .shadow(radius: 5)

//            VStack {
                Text(text)
                    .font(.largeTitle)
                    .foregroundColor(.black)
//            }
//            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 200, height: 80)
    }
}

enum AppState {
    case listeningToCommand
    case listeningToParameters(command: String)
}
struct Command {
    let code: String
    var value: String
    
    init(code: String = "", value: String = "") {
        self.code = code
        self.value = value
    }
}
struct Test: View {
//    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @State private var appState: AppState = .listeningToCommand
    private let commands = ["count", "code", "erase", "back"]
    @State private var currentCommand: Command = Command()
    private let transcript = "Code one two"
    var body: some View {
        VStack {
            Text(currentCommand.code)
                .padding()
            Text(currentCommand.value)
                .padding()
            
            Button(action: {
                if !isRecording {
                    startSpeechRecognition()
//                    speechRecognizer.transcribe()
                } else {
//                    speechRecognizer.stopTranscribing()
                }
                
                isRecording.toggle()
            }) {
                Text(isRecording ? "Stop" : "Record")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(isRecording ? Color.red : Color.blue)
                    .cornerRadius(10)
            }
        }
    }
    
    func startSpeechRecognition() {
           // Simulated speech recognition logic
           let recognizedWords = transcript.lowercased().split(separator: " ").map { String($0) }
           
           for word in recognizedWords {
               if commands.contains(word) {
                   appState = .listeningToParameters(command: word)
//                   TODO: Save the last command before starting the new one
                   currentCommand = Command(code: word)
                   
               } else if let digitValue = digitValue(from: word) {
                   currentCommand = Command(code: currentCommand.code, value: currentCommand.value + digitValue)
                   appState = .listeningToParameters(command: word)
               } else {
                   print("Invalid word \(word)")
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
