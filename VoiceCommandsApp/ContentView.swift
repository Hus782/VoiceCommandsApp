//
//  ContentView.swift
//  VoiceCommandsApp
//
//  Created by user240865 on 8/11/23.
//

import SwiftUI

//struct ContentView: View {
//    var body: some View {
//
//        VStack {
//
//            List {
//                Section{
//                    CardView(text: "Status")
//                    CardView(text: "Current")
//                }
//                Section(header: Text("Values")) {
//                    CardView(text: "Testing")
//                    CardView(text: "Testing")
//                    CardView(text: "Testing")
//                }
//               }
//            Button("Button title") {
//                print("Button tapped!")
//            }
//
//        }
////        .padding()
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}

struct CardView: View {
    let title: String
    let content: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white)
//                .shadow(radius: 5)

            VStack {
                Text(title)
//                    .font(.)
                    .foregroundColor(.black)
                Text(content).foregroundColor(.black)
            }
//            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 200, height: 80)
    }
}

enum AppState: String {
    case listeningToCommand
    case listeningToParameters
}
struct Command: Identifiable, Hashable {
    let id = UUID()
    let code: String
    var value: String
    
    init(code: String = "", value: String = "") {
        self.code = code
        self.value = value
    }
}

enum Commands: String {
    case code
    case count
    case erase
    case back
}


struct Test: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @State private var appState: AppState = .listeningToCommand
//    private let commands = ["count", "code", "erase", "back"]
    @State private var currentCommand: Command = Command()
//    private let transcript = "Code one two"
    private let commands: [Command] = []
    var body: some View {
        VStack {
            List {
                Section{
                    CardView(title: "Status", content: appState.rawValue)
                    CardView(title: currentCommand.code, content: currentCommand.value)
                    CardView(title: "Current text", content: "")
                }
                Section(header: Text("Values")) {
                    ForEach(commands, id: \.self) { command in
                        CardView(title: command.code, content: command.value)
                    }
                }
            
               }
            
            Button(action: {
                if !isRecording {
                    startSpeechRecognition()
                    speechRecognizer.transcribe()
                } else {
                    speechRecognizer.stopTranscribing()
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
        let recognizedWords = speechRecognizer.transcript.lowercased().split(separator: " ").map { String($0) }
           
           for word in recognizedWords {
               switch Commands(rawValue: word) {
               case .code:
                   appState = .listeningToParameters
//                   TODO: Save the last command before starting the new one
                   currentCommand = Command(code: word)
               case .back, .erase, .count:
                   appState = .listeningToCommand
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
