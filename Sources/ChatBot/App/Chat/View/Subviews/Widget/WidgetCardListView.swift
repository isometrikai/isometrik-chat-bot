//
//  SwiftUIView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 25/09/24.
//

import SwiftUI

struct WidgetCardListView: View {
    
    // MARK: - PROPERTIES
    
    var widgetData: [WidgetData]
    var type: WidgetType = .cardView
    var appTheme: AppTheme
    var gptUIPreference: MyGptUIPreferences?
    
    var widgetAction: ((ChatBotWidget?)->Void)?
    var widgetViewAllResponseAction: ((String?, [WidgetData]? , WidgetType)->Void)?
    
    // MARK: - MAIN
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                
                // Loop through the first 3 widgets
                if let widget = getCardWidget(){
                    ForEach(widget.prefix(3), id: \.self) { widget in
                        WidgetCardView(
                            appTheme: appTheme,
                            widgetData: widget,
                            type: type,
                            gptUIPreference: gptUIPreference
                        ) { widget in
                            widgetAction?(widget)
                        }
                        .frame(width: 250)
                        .padding(.vertical, 4)
                    }
                    
                    if widget.count > 3 {
                        // Add "View All" button
                        Button {
                            widgetViewAllResponseAction?("", widgetData, type)
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
    
    func getCardWidget() -> [ChatBotWidget]? {
        guard let widgetUnions = widgetData.first?.widget else {
            return nil
        }
        
        // Map the array of WidgetUnion to only include ChatBotWidget cases
        let chatBotWidgets = widgetUnions.compactMap { widgetUnion -> ChatBotWidget? in
            switch widgetUnion {
            case .string(_):
                return nil
            case .widgetClass(let chatBotWidget):
                return chatBotWidget
            }
        }
        
        // Return nil if no ChatBotWidget found, otherwise return the array
        return chatBotWidgets.isEmpty ? nil : chatBotWidgets
    }
    
}
