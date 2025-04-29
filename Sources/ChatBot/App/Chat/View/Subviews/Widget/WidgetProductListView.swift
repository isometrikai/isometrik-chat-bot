//
//  SwiftUIView.swift
//  ChatBot
//
//  Created by Nikunj's M1 on 29/04/25.
//

import SwiftUI

struct WidgetProductListView: View {
    
    // MARK: - PROPERTIES
    
    var messageData: GptClientResponseModel
    var appTheme: AppTheme
    var gptUIPreference: MyGptUIPreferences?
    
    var widgetAction: ((ChatBotWidget?)->Void)?
    var widgetViewAllResponseAction: ((String?, GptClientResponseModel? , WidgetType)->Void)?
    
    // MARK: - MAIN
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                
                // Loop through the first 3 widgets
                if let widget = messageData.getCardWidget(){
                    ForEach(widget.prefix(3), id: \.self) { widget in
                        WidgetProductView(
                            appTheme: appTheme,
                            widgetData: widget
                        ) { widget in
                            widgetAction?(widget)
                        }
                        .frame(width: 200)
                        .padding(.vertical, 4)
                    }
                    
                    if widget.count > 3 {
                        // Add "View All" button
                        Button {
                            widgetViewAllResponseAction?("", messageData, .productView)
                        } label: {
                            ZStack(alignment: .center) {
                                VStack(alignment: .center) {
                                    Text("+\(widget.count - 3) View More")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(uiColor: UIColor(hex: gptUIPreference?.primaryColor ?? "")))
                                        .underline()
                                }
                            }
                            .frame(maxHeight: .infinity)
                            .frame(width: 120)
                            .background(Color(uiColor: UIColor(hex: gptUIPreference?.primaryColor ?? "").withAlphaComponent(0.1)))
                            .cornerRadius(6)
                            
                        }
                        .buttonStyle(AnimatedButtonStyle())
                    }
                }
                
            }
        }
        .customContentMargins(leading: 65, trailing: 16)
        
    }
    
}

