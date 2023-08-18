//
//  CommandView.swift
//  VoiceCommandsApp
//
//  Created by user240865 on 8/13/23.
//

import SwiftUI

// Showing a single command's code and value, uses optional property used for showing current command
struct CommandView: View {
    let code: String
    let value: String
    let hasTitle: Bool

    var body: some View {
            VStack {
                if hasTitle {
                    Text(Labels.currentStatus)
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                }
                Text(Labels.commandCode + code)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))

                Text(Labels.commandValue + value)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 10))
            }
            .modifier(CardViewStyle())

    }
    
    init(title: String, content: String, hasTitle: Bool = false) {
        self.code = title
        self.value = content
        self.hasTitle = hasTitle
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CommandView(title: "code", content: "12345", hasTitle: true)
    }
}

struct CardViewStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowSeparator(.hidden)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 15)
                        .background(.clear)
                        .foregroundColor(.white)
                        .padding(
                            EdgeInsets(
                                top: 2,
                                leading: 10,
                                bottom: 2,
                                trailing: 10
                            )
                        )
                )
    }
}

