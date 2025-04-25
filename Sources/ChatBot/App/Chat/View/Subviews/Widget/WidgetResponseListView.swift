//
//  SwiftUIView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 25/09/24.
//

import SwiftUI

struct WidgetResponseListView: View {
    
    // MARK: - PROPERTIES
    
    var options: [String]
    var appTheme: AppTheme
    var gptUIPreference: MyGptUIPreferences?
    var isReplied: Bool
    
    var widgetResponseAction: ((String?)->Void)?
    var widgetViewAllResponseAction: ((String?, [String]? , WidgetType)->Void)?
    
    // MARK: - MAIN
    
    var body: some View {
        
        if !isReplied {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    
                    // Loop through the first 3 widgets
                    ForEach(options.prefix(3), id: \.self) { option in
                        Button {
                            widgetResponseAction?(option)
                        } label: {
                            Text(option)
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
                    
                    if options.count > 3 {
                        // Add "View All" button
                        Button {
                            widgetViewAllResponseAction?("", options, .responseView)
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
