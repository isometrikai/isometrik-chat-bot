//
//  SenderMessageView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import SwiftUI

struct MessageView: View {
    
    // MARK: - PROPERTIES
    
    var appTheme: AppTheme
    var message: CustomMessageModel
    var gptUIPreference: MyGptUIPreferences?
    var widgetAction: ((ChatBotWidget?)->Void)?
    
    private var leadingPadding: CGFloat {
        message.isFromUser ? 40 : 0
    }
    
    private var trailingPadding: CGFloat {
        message.isFromUser ? 0 : 40
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            HStack(alignment: message.isFromUser ? .center : .bottom, spacing: 10){
                if message.isFromUser {
                    Spacer()
                    Text(message.text)
                        .padding(12)
                        .background(Color(hex: "\(gptUIPreference?.userBubbleColor ?? "#2E8AFF")"))
                        .clipShape(RoundedCorner(topLeft: 8, topRight: 8, bottomLeft: 8, bottomRight: 0))
                        .foregroundColor(Color(hex: "\(gptUIPreference?.userBubbleFontColor ?? "#FFFFFF")"))
                        .font(.custom("\(gptUIPreference?.fontStyle ?? "")", size: 14))
                } else {
                    appTheme.theme.images.appLogo
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                    
                    if message.isResponding {
                        
                        ZStack(alignment: .bottomLeading) {
                            Rectangle()
                                .fill(Color(hex: "\(gptUIPreference?.botBubbleColor ?? "#F6F6F6")"))
                                .frame(width: 100 ,height: 50)
                                .clipShape(RoundedCorner(topLeft: 8, topRight: 8, bottomLeft: 0, bottomRight: 8))
                            LottieView(filename: getLoaderFileName())
                                .scaledToFit()
                                .frame(width: 100)
                                .offset(x: 0)
                                .scaleEffect(3)
                        }
                        .frame(height: 50)
                        .background(Color.red.opacity(0.1))
                        
                    } else {
                        Text(message.text)
                            .padding(12)
                            .background(Color(hex: "\(gptUIPreference?.botBubbleColor ?? "#F6F6F6")"))
                            .clipShape(RoundedCorner(topLeft: 8, topRight: 8, bottomLeft: 0, bottomRight: 8))
                            .foregroundColor(Color(hex: "\(gptUIPreference?.botBubbleFontColor ?? "#262626")"))
                            .font(.custom("\(gptUIPreference?.fontStyle ?? "")", size: 14))
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 5)
            .padding(.leading, leadingPadding)
            .padding(.trailing, trailingPadding)
            
            if message.messageData != nil && message.messageData?.widgetData?.count ?? 0 > 0 {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach((message.messageData?.widgetData?.first?.widget ?? [])!, id: \.self) { widget in
                            WidgetView(
                                appTheme: appTheme,
                                widgetData: widget
                            ) { widget in
                                widgetAction?(widget)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .modifier(ContentMarginsModifier())
            }
            
        } //: VSTACK
    }//: BODY
    
    
    func getLoaderFileName() -> String {
        
        let botBubbleColorHexString = gptUIPreference?.botBubbleColor ?? "#F6F6F6"
        let textStyle = textColorStyle(forHex: botBubbleColorHexString)
        
        if textStyle == "dark" {
            return appTheme.theme.jsonFiles.botResponseLoaderBlack
        } else {
            return appTheme.theme.jsonFiles.botResponseLoaderWhite
        }
        
    }
    
}

fileprivate struct ContentMarginsModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .contentMargins(.leading, 65, for: .scrollContent)
                .contentMargins(.trailing, 16, for: .scrollContent)
        } else {
            content
                .padding(.leading, 65)
                .padding(.trailing, 16)
        }
    }
}
