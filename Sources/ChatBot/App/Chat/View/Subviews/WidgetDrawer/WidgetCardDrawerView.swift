//
//  SwiftUIView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 26/09/24.
//

import SwiftUI

struct WidgetCardDrawerView: View {
    
    // MARK: - PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.customScheme) var colorScheme
    var title: String
    var widgetData: [WidgetData]
    var type: WidgetType = .cardView
    var appTheme: AppTheme
    var gptUIPreference: MyGptUIPreferences?
    
    var responseCallback: ((ChatBotWidget?)->Void)?
    
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
                    VStack(alignment: .leading, spacing: 12) {
                        if let widget = getCardWidget() {
                            ForEach(widget, id: \.self) { widget in
                                WidgetCardView(
                                    appTheme: appTheme,
                                    widgetData: widget,
                                    type: type,
                                    gptUIPreference: gptUIPreference
                                ) { widget in
                                    responseCallback?(widget)
                                    dismiss()
                                }
                                .frame(maxHeight: 300)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 4)
                            }
                        }
                        
                        if let options = getOptionsWidget() {
                            HStack(spacing: 8) { // Add spacing between buttons if needed
                                Spacer() // This pushes content to center
                                ForEach(options, id: \.self) { option in
                                    Button(action: {
                                        
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
                                Spacer() // This ensures the content is centered
                            }
                            .padding(.horizontal, 16) // Add horizontal padding to match the cards above
                        }
                        }
                } //: SCROLLVIEW
                .customContentMargins(bottom: 50)
                
                Spacer()
            } //: VSTACK
            .edgesIgnoringSafeArea(.all)
        }
        
    }
    
    func getCardWidget() -> [ChatBotWidget]? {
        var allChatBotWidgets: [ChatBotWidget] = []
        
        // Loop through each element in widgetData
        for dataElement in widgetData {
            if let widgetUnions = dataElement.widget {
                // Extract ChatBotWidget cases and add to our array
                for widgetUnion in widgetUnions {
                    if case .widgetClass(let chatBotWidget) = widgetUnion {
                        allChatBotWidgets.append(chatBotWidget)
                    }
                }
            }
        }
        
        // Return nil if no ChatBotWidget found, otherwise return the array
        return allChatBotWidgets.isEmpty ? nil : allChatBotWidgets
    }
    
    func getOptionsWidget() -> [String]? {
        var allChatBotWidgets: [String] = []
        
        // Loop through each element in widgetData
        for dataElement in widgetData {
            if let widgetUnions = dataElement.widget {
                // Extract ChatBotWidget cases and add to our array
                for widgetUnion in widgetUnions {
                    if case .string(let chatBotWidget) = widgetUnion {
                        allChatBotWidgets.append(chatBotWidget)
                    }
                }
            }
        }
        
        // Return nil if no ChatBotWidget found, otherwise return the array
        return allChatBotWidgets.isEmpty ? nil : allChatBotWidgets
    }
    
    
}
