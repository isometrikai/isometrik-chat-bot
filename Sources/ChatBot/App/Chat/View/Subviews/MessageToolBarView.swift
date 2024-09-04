//
//  MessageToolBarView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 31/08/24.
//

import SwiftUI

struct MessageToolBarView: View {
    
    // MARK: - PROPERTIES
    @State var messageInput: String = ""
    @FocusState.Binding var isFocused: Bool
    @Binding var isBotTyping: Bool
    var appTheme: AppTheme
    
    var sendAction: ((String)->Void)?
    var cancelAction: (()->Void)?

    // MARK: - BODY
    
    var body: some View {
        
        HStack {
            TextField("Write a message", text: $messageInput)
                .font(.system(size: 14))
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(hex: "#DDDDDD"), lineWidth: 1)
                )
                .frame(height: 40)
                .focused($isFocused)
            
            Button(action: {
                if isBotTyping {
                    // action for canceling the request
                    cancelAction?()
                } else {
                    withAnimation(.spring()) {
                        // Action for the send button
                        sendAction?(messageInput)
                        messageInput = ""
                    }
                }
            }) {
                let image = isBotTyping ? appTheme.theme.images.stopResponse : appTheme.theme.images.sendMessage
                
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
            .scaleEffect(isBotTyping ? 0.8 : 1)
            .animation(.easeInOut(duration: 0.1), value: isBotTyping)
        }//: HSTACK
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
        
    }
}

//#Preview {
//    MessageToolBarView(
//        isFocused: $isFocused, 
//        isBotTyping: .constant(true)
//        sendAction: { message in
//            print(message)
//        },
//        cancelAction: {
//            print("message cancelled!")
//        }
//    )
//}
