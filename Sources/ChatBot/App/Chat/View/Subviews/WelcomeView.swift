//
//  WelcomeView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 24/08/24.
//

import SwiftUI

struct WelcomeView: View {
    
    // MARK: - PROPERTIES
    var chatBotName: String
    var appTheme: AppTheme
    var myGptSessionData: MyGptsResponseModel?
    var uiPreference: MyGptUIPreferences?
    @Binding var hideSuggestedReplies: Bool
    var repliedWith: (String) -> Void
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0){
                appTheme.theme.images.welcomeBot
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .offset(y: 35)
                    .clipped()
                VStack(alignment: .leading) {
                    Text("Meet \(chatBotName)")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                    Text(myGptSessionData?.data?.first?.welcomeMessage?.first ?? "Welcome, what would you like to order today ?")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                }
                .padding(12)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "#2E8AFF"), Color(hex: "#93EDAB")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .clipShape(RoundedCorner(topLeft: 8, topRight: 8, bottomLeft: 0, bottomRight: 8))
                )
                
                if !hideSuggestedReplies {
                    SuggestedRepliesView(replies: myGptSessionData?.data?.first?.suggestedReplies ?? [], uiPreference: uiPreference) { reply in
                        repliedWith(reply)
                    }
                }
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 50))
    }
}
