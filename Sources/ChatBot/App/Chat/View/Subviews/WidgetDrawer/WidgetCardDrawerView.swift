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
    var widgetData: [ChatBotWidget]
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
                        ForEach(widgetData, id: \.self) { widget in
                            WidgetCardView(
                                appTheme: appTheme,
                                widgetData: widget,
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
                } //: SCROLLVIEW
                .customContentMargins(bottom: 50)
                
                Spacer()
            } //: VSTACK
            .edgesIgnoringSafeArea(.all)
        }
        
    }
}
