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
//    @State private var isRecording = false
//    @State private var appState: AppState = .listeningToCommand
//    private let commands = ["count", "code", "erase", "back"]
//    @State private var currentCommand: Command = Command()
//    private let transcript = "Code two three four Count sixty two Code one two Reset Code one one two Count five"
    @State private var commands: [Command] = []
    @StateObject var viewModel = SpeechViewModel()
//    @StateObject private var speechProcessor = SpeechProcessor()

    var body: some View {
        VStack {
            
            List {
                Section{
                    CardView(title: "current_status", content: viewModel.appState.rawValue)
                    CardView(title: viewModel.currentCommand.code, content: "current_command_value" + viewModel.currentCommand.value, hasTitle: true)
                    CardView(title: viewModel.transcript, content: "")
                }
                Section(header: Text("Values")) {
                    ForEach(viewModel.commands, id: \.self) { command in
                        CardView(title: "Command: " + command.code, content: "Value: " + command.value)
                    }
                }
            
            }
                .background(Color(UIColor.systemGroupedBackground))
            
            Button(action: {
                viewModel.toggleRecording()
            }) {
                Text(viewModel.isRecording ? "Stop" : "Record")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(viewModel.isRecording ? Color.red : Color.blue)
                    .cornerRadius(10)
            }
        }.background(Color(UIColor.systemGroupedBackground))
        
    }

}

struct RecordingButtonStyle: ViewModifier {
    var isRecording: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(.white)
            .padding()
            .background(isRecording ? Color.red : Color.blue)
            .cornerRadius(10)
    }
}
