//
//  SpeechView.swift
//  VoiceCommandsApp
//
//  Created by user240865 on 8/17/23.
//

import SwiftUI

// A simple view showing the last recognized speech
struct SpeechView: View {
    let speech: String
    
    var body: some View {

            VStack {
                Text(Labels.detectedSpeechTitle)
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                
                Text(speech)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 7, leading: 10, bottom: 10, trailing: 10))
            }
            .modifier(CardViewStyle())
            
    }
}
    

struct SpeechView_Previews: PreviewProvider {
    static var previews: some View {
        SpeechView(speech: "Test speech")
    }
}
