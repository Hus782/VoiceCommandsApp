//
//  ContentView.swift
//  VoiceCommandsApp
//
//  Created by user240865 on 8/11/23.
//

import SwiftUI



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




struct Command: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let value: String
    
    init(code: String = "", value: String = "") {
        self.code = code
        self.value = value
    }
}




struct ContentView: View {
    @StateObject var speechRecognizber = SpeechRecognizer()
    @State private var isRecording = false
    @State private var appState: AppState = .listeningToCommand
//    private let commands = ["count", "code", "erase", "back"]
    @State private var currentCommand: Command = Command()
//    private let transcript = "Code two three four Count sixty two Code one two Reset Code one one two Count five"
    @State private var commands: [Command] = []
    var body: some View {
        VStack {
            List {
                Section{
                    CardView(title: "Status", content: appState.rawValue)
                    CardView(title: "Command: " + currentCommand.code, content: "Value: " + currentCommand.value, hasTitle: true)
                    CardView(title: speechRecognizber.transcript, content: "")
                }
                Section(header: Text("Values")) {
                    ForEach(commands, id: \.self) { command in
                        CardView(title: "Command: " + command.code, content: "Value: " + command.value)
                    }
                }
            
               }
            
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
        let recognizedWords = speechRecognizber.transcript.lowercased().split(separator: " ").map { String($0) }
           
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
//                   Perform back operation only if app is listening to commands, ignore otherwise
                   if appState == .listeningToCommand {
                       currentCommand = Command(code: word, value: "")
                       commands.popLast()
                   }
               case .reset:
//                   Perform only if listening to parameters for a command
                   if appState == .listeningToParameters {
                       currentCommand = Command(code: "", value: "")
                   }
               default:
//                   Default scenario when a word is not a command
//                   If word is a digit append it to value, otherwise ignore
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
