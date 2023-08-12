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

struct Test: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    
    var body: some View {
        VStack {
            Text(speechRecognizer.transcript)
                .padding()
            
            Button(action: {
                if !isRecording {
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
}
