//
//  CustomNavView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import SwiftUI

struct CustomNavView: View {
    
    var appTheme: AppTheme
    var leadingButtonAction: (() -> Void)?
    var trailingButtonAction: (() -> Void)?
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                
                // leading action button
                Button {
                    leadingButtonAction?()
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                        .padding(10)
                        .overlay {
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        }
                }
                .buttonStyle(AnimatedButtonStyle())
                
                // profile view
                
                HStack {
                    appTheme.theme.images.appLogo
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48)
                    VStack(alignment: .leading) {
                        Text("EazyBee")
                            .font(.system(size: 20, weight: .bold))
                        Text("AI Assistant")
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
                    Image(systemName: "ellipsis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                        .padding(10)
                        .overlay {
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        }
                }
                .buttonStyle(AnimatedButtonStyle())
            }
            .padding(.horizontal, 16)
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
        }
    }
}

