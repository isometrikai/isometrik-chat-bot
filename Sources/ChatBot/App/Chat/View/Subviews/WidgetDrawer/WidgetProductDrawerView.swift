//
//  SwiftUIView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 26/09/24.
//

import SwiftUI

struct WidgetProductDrawerView: View {
    
    // MARK: - PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.customScheme) var colorScheme
    var title: String
    var messageData: GptClientResponseModel
    var appTheme: AppTheme
    var gptUIPreference: MyGptUIPreferences?
    
    var responseCallback: ((ChatBotWidget?,WidgetType)->Void)?
    var responseOptionCallback: ((String?)->Void)?
    
    // MARK: - BODY
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(appTheme.theme.colors.secondaryBackgroundColor(for: colorScheme))
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                
                Text("Suggestions")
                    .foregroundColor(appTheme.theme.colors.primaryColor(for: colorScheme))
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 15)
                
                ScrollView(.vertical, showsIndicators: false) {
                    if let widget = messageData.getCardWidget() {
                        // Two-column grid layout with proper padding
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(widget, id: \.self) { widget in
                                WidgetProductView(
                                    appTheme: appTheme,
                                    widgetData: widget,
                                    gptUIPreference: gptUIPreference
                                ) { widget in
                                    dismiss()
                                    responseCallback?(widget,.productView)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                    }
                    
                    if let options = messageData.getOptionsWidget() {
                        HStack(spacing: 8) {
                            Spacer()
                            ForEach(options, id: \.self) { option in
                                Button(action: {
                                    responseOptionCallback?(option)
                                }) {
                                    Text(option)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .overlay {
                                            getButtonOverlay(isDashed: true, borderColor: Color.white.opacity(0.3))
                                        }
                                        .padding(.vertical, 4)
                                }
                            }
                            Spacer()
                        }
                    }
                } //: SCROLLVIEW
                .customContentMargins(bottom: 50)
                
                Spacer()
            } //: VSTACK
            .edgesIgnoringSafeArea(.all)
        }
    }
}
