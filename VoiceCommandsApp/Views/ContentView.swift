//
//  ContentView.swift
//  VoiceCommandsApp
//
//  Created by user240865 on 8/11/23.
//

import SwiftUI

//The main screen showing the list of commands and related data
struct ContentView: View {
    @StateObject var speechRecognizber = SpeechRecognizer()
    @State private var commands: [CommandModel] = []
    @StateObject var viewModel = SpeechViewModel()

    var body: some View {
        ScrollViewReader { proxy in
            
            VStack {
                
                List {
                    Section{
                        AppStateView(state: viewModel.appState)
                        CommandView(title: viewModel.currentCommand.code?.rawValue ?? "", content: viewModel.currentCommand.value, hasTitle: true)
                        SpeechView(speech: viewModel.transcript)
                    }
                    Section(header: Text(Labels.commandsListHeader)) {
                        ForEach(viewModel.commands, id: \.self) { command in
                            CommandView(title: command.code?.rawValue ?? "", content: command.value).id(command.id)
                        }
                   
                    }
                    .onChange(of: viewModel.commands) { _ in
                        scrollToBottom(proxy: proxy)
                    }
                
                }
                .background(Color(UIColor.systemGroupedBackground))
                .listStyle(InsetGroupedListStyle())
                
                if viewModel.processingData {
                       ProgressView()
                        .controlSize(.large)

                } else {
                    HStack {
                        Button(action: {
                            viewModel.clearData()
                        }) {
                            Text(Labels.clearButtonTitle)
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            viewModel.startImporting()
                        }) {
                            Text(Labels.importButtonTitle)
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .fileImporter(
                            isPresented: $viewModel.importing,
                            allowedContentTypes: [.audio]
                        ) { result in
                            handleRecognitionResults(result: result)
                        }
                        
                        Button(action: {
                            viewModel.toggleRecording()
                        }) {
                            Text(viewModel.isRecording ? Labels.recordButtonStop :Labels.recordButtonStart)
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(viewModel.isRecording ? Color.red : Color.blue)
                                .cornerRadius(10)
                        }
                    }
                }
            }.background(Color(UIColor.systemGroupedBackground))
        }
    }
    

    private func handleRecognitionResults(result: Result<URL, Error>) {
        
        switch result {
        case .success(let file):
            print(file.absoluteString)
            viewModel.transcribeFile(url: file)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation {
               if let lastCommandID = viewModel.commands.last?.id {
                   proxy.scrollTo(lastCommandID, anchor: .bottom)
               }
        }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
