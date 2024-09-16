//
//  CustomNavView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import SwiftUI

struct CustomNavView: View {
    
    @Environment(\.customScheme) var colorScheme
    @Binding var isLeadingActionEnabled: Bool
    @Binding var isTrailingActionEnabled: Bool
    var chatBotName: String
    var chatBotImageUrl: String
    var appTheme: AppTheme
    var leadingButtonAction: (() -> Void)?
    var trailingButtonAction: (() -> Void)?
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(appTheme.theme.colors.primaryBackgroundColor(for: colorScheme))
                .edgesIgnoringSafeArea(.all)
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(appTheme.theme.colors.primaryBackgroundColor(for: colorScheme))
                    .edgesIgnoringSafeArea(.bottom)
                ZStack(alignment: .center) {
                    HStack(alignment: .center) {
                        // leading action button
                        Button {
                            leadingButtonAction?()
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .padding(10)
                                .overlay {
                                    Circle()
                                        .stroke(colorScheme == .light ? Color.gray.opacity(0.2) : Color.white.opacity(0.2), lineWidth: 1)
                                }
                        }
                        .buttonStyle(AnimatedButtonStyle())
                        .disabled(!isLeadingActionEnabled)
                        .opacity(isLeadingActionEnabled ? 1 : 0.5)
                        
                        // profile view
                        
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                                    .frame(width: 45, height: 45)
                                URLImageView(url: URL(string: chatBotImageUrl)!)
                                    .scaledToFill()
                                    .frame(width: 45, height: 45)
                                    .clipped()
                                    .cornerRadius(22.5)
                            }
                            VStack(alignment: .leading) {
                                Text(chatBotName)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .font(.system(size: 20, weight: .bold))
                                Text("AI Assistant")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .font(.system(size: 12))
                            }
                        }
                        .padding(.leading, 8)
                        
                        
                        //:
                        
                        Spacer()
                        
                        // trailing action button
                        Button {
                            trailingButtonAction?()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .padding(10)
                                .overlay {
                                    Circle()
                                        .stroke(colorScheme == .light ? Color.gray.opacity(0.2) : Color.white.opacity(0.2), lineWidth: 1)
                                }
                        }
                        .buttonStyle(AnimatedButtonStyle())
                        .disabled(!isTrailingActionEnabled)
                        .opacity(isTrailingActionEnabled ? 1 : 0.5)
                        .scaleEffect(CGSize(width: isTrailingActionEnabled ? 1 : 0.9, height: isTrailingActionEnabled ? 1 : 0.9))
                        .animation(.smooth(duration: 0.2), value: isTrailingActionEnabled)
                        
                    }
                    .padding(.horizontal, 16)
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 1)
                    }
                }//: ZSTACK
            } //: ZSTACK
        }
        .frame(height: 55)
        
    }
}

