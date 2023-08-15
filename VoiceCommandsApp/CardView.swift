//
//  CardView.swift
//  VoiceCommandsApp
//
//  Created by user240865 on 8/13/23.
//

import SwiftUI

struct CardView: View {
    let title: String
    let content: String
    let hasTitle: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white)
//                .shadow(radius: 5)

            VStack {
                if hasTitle {
                    Text("Current Status")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                }
                Text("current_command_code \(title)")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))

                Text(content).foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 7, leading: 10, bottom: 10, trailing: 10))


            }
//            .padding(20)
            .multilineTextAlignment(.center)
        }
//        .frame(width: 200, height: 80)
    }
    
    init(title: String, content: String, hasTitle: Bool = false) {
        self.title = title
        self.content = content
        self.hasTitle = hasTitle
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(title: "code", content: "12345", hasTitle: true)
    }
}
