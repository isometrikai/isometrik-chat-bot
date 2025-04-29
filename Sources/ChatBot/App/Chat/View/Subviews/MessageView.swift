//
//  SenderMessageView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import SwiftUI

struct MessageView: View {
    
    // MARK: - PROPERTIES
    
    @Environment(\.customScheme) var colorScheme
    var appTheme: AppTheme
    var message: CustomMessageModel
    var chatBotImageUrl: String
    var gptUIPreference: MyGptUIPreferences?
    
    var widgetAction: ((ChatBotWidget?,WidgetType)->Void)?
    var widgetResponseAction: ((String?)->Void)?
    var widgetViewAllResponseAction: ((String?, GptClientResponseModel? , [String]? , WidgetType)->Void)?
    
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
                    
                    ZStack {
                        Circle()
                            .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                            .frame(width: 40, height: 40)
                        
                        if let url = URL(string: chatBotImageUrl) {
                            URLImageView(url: url)
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } else {
                            AnyView(EmptyView())
                        }
                    }
                    
                    if message.isResponding {
                        ZStack(alignment: .bottomLeading) {
                            Rectangle()
                                .fill(Color(uiColor: UIColor(hex: "\(gptUIPreference?.botBubbleColor ?? "#F6F6F6")")))
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
                            .background(Color(uiColor: UIColor(hex: "\(gptUIPreference?.botBubbleColor ?? "#F6F6F6")")))
                            .clipShape(RoundedCorner(topLeft: 8, topRight: 8, bottomLeft: 0, bottomRight: 8))
                            .foregroundColor(Color(uiColor: UIColor(hex: "\(gptUIPreference?.botBubbleFontColor ?? "#181818")")))
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
            
            handleWidgets()
            
        } //: VSTACK
    }//: BODY
    
    
    // MARK: - FUNCTIONS
    
    private func handleWidgets() -> some View {
        let widgetType = getWidgetType()
        guard let messageData = message.messageData else {return AnyView(EmptyView())}
        
        switch widgetType {
        case .cardView:
            
            return AnyView(
                WidgetCardListView(
                    messageData: messageData,
                    appTheme: appTheme,
                    gptUIPreference: gptUIPreference,
                    widgetAction: { widgetData in
                        widgetAction?(widgetData,.cardView)
                    },
                    widgetViewAllResponseAction: { title, widgetData, widgetType in
                        widgetViewAllResponseAction?(title, widgetData, [""], widgetType)
                    }
                )
            )

        case .productView:
            return AnyView(
                WidgetProductListView(
                    messageData: messageData,
                    appTheme: appTheme,
                    gptUIPreference: gptUIPreference,
                    widgetAction: { widgetData in
                        widgetAction?(widgetData,.productView)
                    },
                    widgetViewAllResponseAction: { title, widgetData, widgetType in
                        widgetViewAllResponseAction?(title, widgetData, [""], widgetType)
                    }
                )
            )
            
        case .responseView:
            return AnyView(
                WidgetResponseListView(
                    messageData: messageData,
                    appTheme: appTheme,
                    gptUIPreference: gptUIPreference,
                    isReplied: getRepliedStatusToSuggestions(),
                    widgetResponseAction: { reply in
                        widgetResponseAction?(reply)
                    },
                    widgetViewAllResponseAction: { title, options, widgetType in
                        widgetViewAllResponseAction?( title, nil, options, widgetType)
                    }
                )
            )
        default:
            return AnyView(EmptyView())
        }
    }
    
    func getRepliedStatusToSuggestions() -> Bool {
        
        guard let widgetData = message.messageData?.widgetData, !widgetData.isEmpty else {
            return false
        }
        
        return widgetData.first?.repliedStatusToSuggestions ?? false
        
    }
    
    func getLoaderFilePath() -> String {
        
        if colorScheme == .light {
            return appTheme.theme.jsonFiles.botResponseLoaderBlack
        } else {
            return appTheme.theme.jsonFiles.botResponseLoaderWhite
        }
        
    }
    
   func getWidgetData() -> [WidgetData] {
        return message.messageData?.widgetData ?? []
        
    }
    
    func getWidgetType() -> WidgetType? {

        guard let widgetData = message.messageData?.widgetData, !widgetData.isEmpty else {
            return nil
        }
        
        let widgetTypeString = widgetData.first?.type ?? ""
        return WidgetType(rawValue: widgetTypeString)
        
    }
    
}
