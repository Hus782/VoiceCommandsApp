//
//  AppStateView.swift
//  VoiceCommandsApp
//
//  Created by user240865 on 8/17/23.
//

import SwiftUI

// A view showing the current state of the app
struct AppStateView: View {
    let state: AppState

    var body: some View {
        VStack {
            Text(Labels.appStateTitle)
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
            
            Text(state.rawValue)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                
            
        }.modifier(CardViewStyle())
        }
}
    

struct AppStateView_Previews: PreviewProvider {
    static var previews: some View {
        AppStateView(state: .listeningToCommand)
    }
}
