//
//  SenderMessageView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import SwiftUI

struct MessageView: View {
    
    // MARK: - PROPERTIES
    
    @Environment(\.colorScheme) var colorScheme
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
                        .background(Color(uiColor: UIColor(hex: "\(gptUIPreference?.userBubbleColor ?? "#2E8AFF")")))
                        .clipShape(RoundedCorner(topLeft: 8, topRight: 8, bottomLeft: 8, bottomRight: 0))
                        .foregroundColor(Color(uiColor: UIColor(hex: "\(gptUIPreference?.userBubbleFontColor ?? "#FFFFFF")")))
                        .font(.custom("\(gptUIPreference?.fontStyle ?? "")", size: 14))
                } else {
                    appTheme.theme.images.appLogo
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                    
                    if message.isResponding {
                        ZStack(alignment: .bottomLeading) {
                            Rectangle()
                                .fill(colorScheme == .dark ? appTheme.theme.colors.primaryBackgroundColorDarkMode : Color(uiColor: UIColor(hex: "\(gptUIPreference?.botBubbleColor ?? "#F6F6F6")")))
                                .frame(width: 100 ,height: 50)
                                .clipShape(RoundedCorner(topLeft: 8, topRight: 8, bottomLeft: 0, bottomRight: 8))
                            LottieView(filePath: getLoaderFilePath())
                                .scaledToFit()
                                .frame(width: 100)
                                .offset(x: 0)
                                .scaleEffect(3)
                        }
                        .frame(height: 50)
                        .overlay {
                            RoundedCorner(topLeft: 8, topRight: 8, bottomLeft: 0, bottomRight: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        }
                    } else {
                        Text(message.text)
                            .padding(12)
                            .background(colorScheme == .dark ? appTheme.theme.colors.primaryBackgroundColorDarkMode : Color(uiColor: UIColor(hex: "\(gptUIPreference?.botBubbleColor ?? "#F6F6F6")")))
                            .clipShape(RoundedCorner(topLeft: 8, topRight: 8, bottomLeft: 0, bottomRight: 8))
                            .foregroundColor(colorScheme == .dark ? Color.white : Color(uiColor: UIColor(hex: "\(gptUIPreference?.botBubbleFontColor ?? "#262626")")))
                            .font(.custom("\(gptUIPreference?.fontStyle ?? "")", size: 14))
                            .overlay {
                                RoundedCorner(topLeft: 8, topRight: 8, bottomLeft: 0, bottomRight: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            }
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
                                widgetData: widget,
                                gptUIPreference: gptUIPreference
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
    
    
    func getLoaderFilePath() -> String {
        
        if colorScheme == .light {
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
