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
    var widgetAction: ((ChatBotWidget?)->Void)?
    var widgetResponseAction: ((String?)->Void)?
    var widgetViewAllResponseAction: ((String?, [ChatBotWidget]?)->Void)?
    
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
                        URLImageView(url: URL(string: chatBotImageUrl)!)
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
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
                            .foregroundColor(Color(uiColor: UIColor(hex: "\(gptUIPreference?.botBubbleFontColor ?? "#F6F6F6")")))
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
            
            if !getWidgetData().isEmpty {
                
                let widgetData = getWidgetData()
                let widgetType = getWidgetType()
                
                switch widgetType {
                case .cardView:
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 12) {
                            ForEach(widgetData, id: \.self) { widget in
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
                    .customContentMargins(leading: 65, trailing: 16)
                case .responseView:
                    if !getRepliedStatusToSuggestions() {
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
                                                getButtonOverlay(color: Color(hex: gptUIPreference?.primaryColor ?? ""))
                                            }
                                            .padding(.vertical, 4)
                                    }
                                    .buttonStyle(AnimatedButtonStyle())
                                }
                                
                                // Add "View All" button
                                Button {
                                    widgetViewAllResponseAction?("", widgetData)
                                } label: {
                                    Text("View All")
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .overlay {
                                            getButtonOverlay(isDashed: true, color: Color.white.opacity(0.5))
                                        }
                                        .padding(.vertical, 4)
                                }
                                .buttonStyle(AnimatedButtonStyle())
                                
                            }//: LazyHStack
                        }
                        .customContentMargins(leading: 65, trailing: 16)
                    }
                case nil:
                    AnyView(EmptyView())
                }
                
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
    
    func getWidgetData() -> [ChatBotWidget] {
        
        guard let widgetData = message.messageData?.widgetData, !widgetData.isEmpty else {
            return []
        }
        return widgetData.first?.widget ?? []
        
    }
    
    func getWidgetType() -> WidgetType? {

        guard let widgetData = message.messageData?.widgetData, !widgetData.isEmpty else {
            return nil
        }
        
        let widgetTypeString = widgetData.first?.type ?? ""
        return WidgetType(rawValue: widgetTypeString)
        
    }
    
    func getRepliedStatusToSuggestions() -> Bool {
        
        guard let widgetData = message.messageData?.widgetData, !widgetData.isEmpty else {
            return false
        }
        
        return widgetData.first?.repliedStatusToSuggestions ?? false
        
    }
    
}
