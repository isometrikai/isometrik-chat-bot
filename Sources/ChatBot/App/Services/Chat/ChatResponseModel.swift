//
//  ChatResponseModel.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import Foundation

public struct GptClientResponseModel: Decodable {
    
    public let text: String?
    //let imageData: [JSONAny]?
    public let websiteSource: String?
    //let sources: [JSONAny]?
    public var widgetData: [WidgetData]?
    public let inputTokenCount, id, parsedRequestID, requestID: Int?
    
    enum CodingKeys: String, CodingKey {
        case text
//        case imageData = "image_data"
        case websiteSource = "website_source"
//        case sources
        case widgetData
        case inputTokenCount = "input_token_count"
        case id
        case parsedRequestID = "parsed_request_id"
        case requestID = "request_id"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.websiteSource = try container.decodeIfPresent(String.self, forKey: .websiteSource)
        self.widgetData = try container.decodeIfPresent([WidgetData].self, forKey: .widgetData)
        self.inputTokenCount = try container.decodeIfPresent(Int.self, forKey: .inputTokenCount)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.parsedRequestID = try container.decodeIfPresent(Int.self, forKey: .parsedRequestID)
        self.requestID = try container.decodeIfPresent(Int.self, forKey: .requestID)
    }
    
}

public struct WidgetData: Decodable, Hashable {
    
    public let widgetId: Int?
    public let type: String?
    public let widget: [ChatBotWidget]?
    public var repliedStatusToSuggestions: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case widgetId
        case type, widget
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.widgetId = try container.decodeIfPresent(Int.self, forKey: .widgetId)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.widget = try container.decodeIfPresent([ChatBotWidget].self, forKey: .widget)
    }
    
}

public struct ChatBotWidget: Decodable, Hashable {
    
    public var id: UUID = UUID()
    public var imageURL: String?
    public let productID: String?
    public var title: String?
    public let description: String?
    public let subtitle, buttontext: String?
    public let link: String?
    public let actionHandler: String?
    public var price: String?
    public let tableReservations: Bool?
    public var supportedOrderTypes, averageCost: Int?
    public let currencyCode: String?
    public var discountPrice: String?
    public var averageRating: Double?
    public var storeId: String?
    public var actionText: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL
        case productID = "productId"
        case title, description, subtitle, buttontext, link, actionHandler, price
        case tableReservations = "table_reservations"
        case supportedOrderTypes = "supported_order_types"
        case averageCost = "average_cost"
        case currencyCode = "currency_code"
        case discountPrice = "discount_price"
        case averageRating = "avg_rating"
        case storeId = "store_id"
        case actionText
    }
    
    public init(imageURL: String?, title: String?, subtitle: String?, price: String?, currencyCode: String?, averageCost:Int?, supportedOrderTypes: Int?, actionText: String?) {
        self.id = UUID()
        self.imageURL = imageURL
        self.productID = nil
        self.title = title
        self.description = nil
        self.subtitle = subtitle
        self.buttontext = nil
        self.link = nil
        self.actionHandler = nil
        self.price = price
        self.tableReservations = nil
        self.supportedOrderTypes = supportedOrderTypes
        self.averageCost = averageCost
        self.currencyCode = currencyCode
        self.discountPrice = nil
        self.actionText = nil
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        self.productID = try container.decodeIfPresent(String.self, forKey: .productID)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        self.buttontext = try container.decodeIfPresent(String.self, forKey: .buttontext)
        self.link = try container.decodeIfPresent(String.self, forKey: .link)
        self.actionHandler = try container.decodeIfPresent(String.self, forKey: .actionHandler)
        self.price = try container.decodeIfPresent(String.self, forKey: .price)
        self.tableReservations = try container.decodeIfPresent(Bool.self, forKey: .tableReservations)
        self.supportedOrderTypes = try container.decodeIfPresent(Int.self, forKey: .supportedOrderTypes)
        self.averageCost = try container.decodeIfPresent(Int.self, forKey: .averageCost)
        self.currencyCode = try container.decodeIfPresent(String.self, forKey: .currencyCode)
        self.discountPrice = try container.decodeIfPresent(String.self, forKey: .discountPrice)
        self.averageRating = try container.decodeIfPresent(Double.self, forKey: .averageRating)
        self.storeId = try container.decodeIfPresent(String.self, forKey: .storeId)
        self.actionText = try container.decodeIfPresent(String.self, forKey: .actionText)
    }
    
}

// MARK: - My GPTs Response model

public struct MyGptsResponseModel: Decodable {
    
    public let message: String?
    public let data: [MyGptData]?
    public let count: Int?
    
    enum CodingKeys: CodingKey {
        case message
        case data
        case count
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.data = try container.decodeIfPresent([MyGptData].self, forKey: .data)
        self.count = try container.decodeIfPresent(Int.self, forKey: .count)
    }
    
}

public struct MyGptData: Decodable {
    
    public let id: Int?
    public let botIdentifier, accountID, projectID, name: String?
    public let userID: String?
    public let uiPreferences: MyGptUIPreferences?
    public let persona, timezone, prompts: String?
    public let suggestedReplies: [String]?
    public let botAIEngine: Int?
    public let supportedAIName, supportedAIModelName: String?
    public let profileImage: String?
    public let knowledgeSources: [KnowledgeSource]?
    public let status: [MyGptStatus]?
    public let createdAt, botType: String?
    public let welcomeMessage: [String]?
    public let appType: Int?
    public let additionalInstruction: String?
    public let temperature: Double?
    public let percentage, knowledgeBase: Int?
    public let functions: [Int]?
    public let workflows: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case botIdentifier = "bot_identifier"
        case accountID = "account_id"
        case projectID = "project_id"
        case name
        case userID = "user_id"
        case uiPreferences = "ui_preferences"
        case persona, timezone, prompts
        case suggestedReplies = "suggested_replies"
        case botAIEngine = "bot_ai_engine"
        case supportedAIName = "supported_ai_name"
        case supportedAIModelName = "supported_ai_model_name"
        case profileImage = "profile_image"
        case knowledgeSources = "knowledge_sources"
        case status
        case createdAt = "created_at"
        case botType = "bot_type"
        case welcomeMessage = "welcome_message"
        case appType = "app_type"
        case additionalInstruction = "additional_instruction"
        case temperature, percentage
        case knowledgeBase = "knowledge_base"
        case functions, workflows
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.botIdentifier = try container.decodeIfPresent(String.self, forKey: .botIdentifier)
        self.accountID = try container.decodeIfPresent(String.self, forKey: .accountID)
        self.projectID = try container.decodeIfPresent(String.self, forKey: .projectID)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.userID = try container.decodeIfPresent(String.self, forKey: .userID)
        self.uiPreferences = try container.decodeIfPresent(MyGptUIPreferences.self, forKey: .uiPreferences)
        self.persona = try container.decodeIfPresent(String.self, forKey: .persona)
        self.timezone = try container.decodeIfPresent(String.self, forKey: .timezone)
        self.prompts = try container.decodeIfPresent(String.self, forKey: .prompts)
        self.suggestedReplies = try container.decodeIfPresent([String].self, forKey: .suggestedReplies)
        self.botAIEngine = try container.decodeIfPresent(Int.self, forKey: .botAIEngine)
        self.supportedAIName = try container.decodeIfPresent(String.self, forKey: .supportedAIName)
        self.supportedAIModelName = try container.decodeIfPresent(String.self, forKey: .supportedAIModelName)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        self.knowledgeSources = try container.decodeIfPresent([KnowledgeSource].self, forKey: .knowledgeSources)
        self.status = try container.decodeIfPresent([MyGptStatus].self, forKey: .status)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.botType = try container.decodeIfPresent(String.self, forKey: .botType)
        self.welcomeMessage = try container.decodeIfPresent([String].self, forKey: .welcomeMessage)
        self.appType = try container.decodeIfPresent(Int.self, forKey: .appType)
        self.additionalInstruction = try container.decodeIfPresent(String.self, forKey: .additionalInstruction)
        self.temperature = try container.decodeIfPresent(Double.self, forKey: .temperature)
        self.percentage = try container.decodeIfPresent(Int.self, forKey: .percentage)
        self.knowledgeBase = try container.decodeIfPresent(Int.self, forKey: .knowledgeBase)
        self.functions = try container.decodeIfPresent([Int].self, forKey: .functions)
        self.workflows = try container.decodeIfPresent(String.self, forKey: .workflows)
    }
    
}


public struct KnowledgeSource: Decodable {
    
    public let filename: String?
    public let source: String?
    public let addedOn: Int64?
    
    enum CodingKeys: CodingKey {
        case filename
        case source
        case addedOn
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.filename = try container.decodeIfPresent(String.self, forKey: .filename)
        self.source = try container.decodeIfPresent(String.self, forKey: .source)
        self.addedOn = try container.decodeIfPresent(Int64.self, forKey: .addedOn)
    }
    
}

public struct MyGptStatus: Decodable {
    
    public let id: String?
    public let timestamp: Int64?
    public let statusText: String?
    
    enum CodingKeys: CodingKey {
        case id
        case timestamp
        case statusText
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.timestamp = try container.decodeIfPresent(Int64.self, forKey: .timestamp)
        self.statusText = try container.decodeIfPresent(String.self, forKey: .statusText)
    }
    
}

public struct MyGptUIPreferences: Decodable {
    
    public let modeTheme: Int?
    public let primaryColor, botBubbleColor, userBubbleColor, fontSize: String?
    public let fontStyle, botBubbleFontColor, userBubbleFontColor: String?
    
    enum CodingKeys: String, CodingKey {
        case modeTheme = "mode_theme"
        case primaryColor = "primary_color"
        case botBubbleColor = "bot_bubble_color"
        case userBubbleColor = "user_bubble_color"
        case fontSize = "font_size"
        case fontStyle = "font_style"
        case botBubbleFontColor = "bot_bubble_font_color"
        case userBubbleFontColor = "user_bubble_font_color"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.modeTheme = try container.decodeIfPresent(Int.self, forKey: .modeTheme)
        self.primaryColor = try container.decodeIfPresent(String.self, forKey: .primaryColor)
        self.botBubbleColor = try container.decodeIfPresent(String.self, forKey: .botBubbleColor)
        self.userBubbleColor = try container.decodeIfPresent(String.self, forKey: .userBubbleColor)
        self.fontSize = try container.decodeIfPresent(String.self, forKey: .fontSize)
        self.fontStyle = try container.decodeIfPresent(String.self, forKey: .fontStyle)
        self.botBubbleFontColor = try container.decodeIfPresent(String.self, forKey: .botBubbleFontColor)
        self.userBubbleFontColor = try container.decodeIfPresent(String.self, forKey: .userBubbleFontColor)
    }
    
}
