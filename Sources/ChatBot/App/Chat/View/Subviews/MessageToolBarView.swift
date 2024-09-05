//
//  MessageToolBarView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 31/08/24.
//

import SwiftUI

struct MessageToolBarView: View {
    
    // MARK: - PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    @State var messageInput: String = ""
    @FocusState.Binding var isFocused: Bool
    @Binding var isBotTyping: Bool
    var appTheme: AppTheme
    
    var sendAction: ((String)->Void)?
    var cancelAction: (()->Void)?

    // MARK: - BODY
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(appTheme.theme.colors.primaryBackgroundColor(for: colorScheme))
            HStack {
                TextField("Write a message", text: $messageInput)
                    .font(.system(size: 14))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .background(appTheme.theme.colors.secondaryBackgroundColor(for: colorScheme))
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(colorScheme == .light ? Color.gray.opacity(0.2) : Color.white.opacity(0.2), lineWidth: 1)
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
                    let image = isBotTyping ? appTheme.theme.images.stopResponse.renderingMode(.template) : appTheme.theme.images.sendMessage.renderingMode(.original)
                    
                    image
                        .resizable()
                        .foregroundColor(colorScheme == .dark ? appTheme.theme.colors.secondaryColor : appTheme.theme.colors.primaryColor )
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                .scaleEffect(isBotTyping ? 0.8 : 1)
                .animation(.easeInOut(duration: 0.1), value: isBotTyping)
            }//: HSTACK
            .padding(.horizontal, 16)
            VStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 1)
                Spacer()
            }
        }
        .frame(height: 60)
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
