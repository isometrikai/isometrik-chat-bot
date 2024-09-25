//
//  SwiftUIView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 25/09/24.
//

import SwiftUI

struct ResponseWidgetView: View {
    
    // MARK: - PROPERTIES
    
    var widgetData: [ChatBotWidget]
    var appTheme: AppTheme
    var gptUIPreference: MyGptUIPreferences?
    var isReplied: Bool
    
    var widgetResponseAction: ((String?)->Void)?
    var widgetViewAllResponseAction: ((String?, [ChatBotWidget]? , WidgetType)->Void)?
    
    // MARK: - MAIN
    
    var body: some View {
        
        if !isReplied {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    
                    // Loop through the first 3 widgets
                    ForEach(widgetData.prefix(3), id: \.self) { widget in
                        Button {
                            widgetResponseAction?(widget.actionText)
                        } label: {
                            Text(widget.actionText ?? "")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: gptUIPreference?.primaryColor ?? ""))
                                .overlay {
                                    getButtonOverlay(borderColor: Color(hex: gptUIPreference?.primaryColor ?? ""))
                                }
                                .padding(.vertical, 4)
                        }
                        .buttonStyle(AnimatedButtonStyle())
                    }
                    
                    if widgetData.count > 3 {
                        // Add "View All" button
                        Button {
                            widgetViewAllResponseAction?("", widgetData, .responseView)
                        } label: {
                            Text("View All")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .overlay {
                                    getButtonOverlay(isDashed: true, borderColor: Color.white.opacity(0.3))
                                }
                                .padding(.vertical, 4)
                        }
                        .buttonStyle(AnimatedButtonStyle())
                    }
                    
                }//: LazyHStack
            }
            .customContentMargins(leading: 65, trailing: 16)
        }
        
    }
    
}
