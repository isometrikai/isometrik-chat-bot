//
//  ChatResponseModel.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import Foundation

public protocol WidgetContent {
    var type: String? { get }
}

extension String: WidgetContent {
    public var type: String? { return "options" }
}

extension ChatBotWidget: WidgetContent {
    public var type: String? { return "stores" }
}

public struct GptClientResponseModel: Decodable {
    
    public let text: String?
    //let imageData: [JSONAny]?
    public let websiteSource: String?
    //let sources: [JSONAny]?
    public var widgetData: [WidgetData]?
    public let inputTokenCount, id, parsedRequestID: Int?
    public let requestID: String?
    
    enum CodingKeys: String, CodingKey {
        case text = "response"
//        case imageData = "image_data"
        case websiteSource = "website_source"
//        case sources
        case widgetData = "widgets"
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
        self.requestID = try container.decodeIfPresent(String.self, forKey: .requestID)
    }
    
}

public struct WidgetData: Decodable, Hashable {
    
    public let widgetId: Int?
    public let type: String?
    public let widget: [ChatBotWidget]?
    public let stringOptions: [String]?
    public var repliedStatusToSuggestions: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case widgetId
        case type
        case widget
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.widgetId = try container.decodeIfPresent(Int.self, forKey: .widgetId)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        
        // Try to decode based on type
        if let type = self.type, let widgetType = WidgetType(rawValue: type) {
            switch widgetType {
            case .cardView:
                self.widget = try container.decodeIfPresent([ChatBotWidget].self, forKey: .widget)
                self.stringOptions = nil
            case .responseView:
                self.stringOptions = try container.decodeIfPresent([String].self, forKey: .widget)
                self.widget = nil
            }
        } else {
            self.widget = nil
            self.stringOptions = nil
        }
    }
    
    public func getWidgetContent() -> [WidgetContent] {
        if let type = self.type, let widgetType = WidgetType(rawValue: type) {
            switch widgetType {
            case .cardView:
                return widget ?? []
            case .responseView:
                return stringOptions ?? []
            }
        }
        
        return []
    }
    
    public func getStores() -> [ChatBotWidget] {
        return widget ?? []
    }
    
    public func getOptions() -> [String] {
        return stringOptions ?? []
    }
}

public struct ChatBotWidget: Decodable, Hashable {
    
    public var id, storename: String?
    public var avgRating: Double?
    public var storeIsOpen: Bool?
    public var storeTag: String?
    public var logoImages: LogoImages?
    public var isTempClose: Bool?
    public var address: StoreAddress?
    public var title: String?
    public var storeImage: String?
    public var distanceKM, distanceMiles: Double?
    public var tableReservations: Bool?
    public var supportedOrderTypes, averageCostForMealForTwo: Int?
    public var currencyCode: String?
    public var currencySymbol: String?
    public var price: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case storename
        case avgRating
        case storeIsOpen = "store_is_open"
        case storeTag = "store_tag"
        case logoImages
        case isTempClose = "is_temp_close"
        case address
        case title = "cuisineDetails"
        case storeImage
        case distanceKM = "distance_km"
        case distanceMiles = "distance_miles"
        case tableReservations
        case supportedOrderTypes
        case averageCostForMealForTwo
        case currencyCode
        case currencySymbol
        case price
    }
    
    public init(id: String? = nil,
                storename: String? = nil,
                avgRating: Double? = nil,
                storeIsOpen: Bool? = nil,
                storeTag: String? = nil,
                logoImages: LogoImages? = nil,
                isTempClose: Bool? = nil,
                address: StoreAddress? = nil,
                title: String? = nil,
                storeImage: String? = nil,
                distanceKM: Double? = nil,
                distanceMiles: Double? = nil,
                tableReservations: Bool? = nil,
                supportedOrderTypes: Int? = nil,
                averageCostForMealForTwo: Int? = nil,
                currencyCode: String? = nil,
                currencySymbol: String? = nil,
                price: String? = nil) {
        self.id = id
        self.storename = storename
        self.avgRating = avgRating
        self.storeIsOpen = storeIsOpen
        self.storeTag = storeTag
        self.logoImages = logoImages
        self.isTempClose = isTempClose
        self.address = address
        self.title = title
        self.storeImage = storeImage
        self.distanceKM = distanceKM
        self.distanceMiles = distanceMiles
        self.tableReservations = tableReservations
        self.supportedOrderTypes = supportedOrderTypes
        self.averageCostForMealForTwo = averageCostForMealForTwo
        self.currencyCode = currencyCode
        self.currencySymbol = currencySymbol
        self.price = price
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.storename = try container.decodeIfPresent(String.self, forKey: .storename)
        self.avgRating = try container.decodeIfPresent(Double.self, forKey: .avgRating)
        self.storeIsOpen = try container.decodeIfPresent(Bool.self, forKey: .storeIsOpen)
        self.storeTag = try container.decodeIfPresent(String.self, forKey: .storeTag)
        self.logoImages = try container.decodeIfPresent(LogoImages.self, forKey: .logoImages)
        self.isTempClose = try container.decodeIfPresent(Bool.self, forKey: .isTempClose)
        self.address = try container.decodeIfPresent(StoreAddress.self, forKey: .address)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.storeImage = try container.decodeIfPresent(String.self, forKey: .storeImage)
        self.distanceKM = try container.decodeIfPresent(Double.self, forKey: .distanceKM)
        self.distanceMiles = try container.decodeIfPresent(Double.self, forKey: .distanceMiles)
        self.tableReservations = try container.decodeIfPresent(Bool.self, forKey: .tableReservations)
        self.supportedOrderTypes = try container.decodeIfPresent(Int.self, forKey: .supportedOrderTypes)
        self.averageCostForMealForTwo = try container.decodeIfPresent(Int.self, forKey: .averageCostForMealForTwo)
        self.currencyCode = try container.decodeIfPresent(String.self, forKey: .currencyCode)
        self.currencySymbol = try container.decodeIfPresent(String.self, forKey: .currencySymbol)
        self.price = try container.decodeIfPresent(String.self, forKey: .price)
    }
}

public struct StoreAddress: Decodable, Hashable {
    public let addressLine1: String?
    public let addressLine2: String?
    public let addressArea: String?
    public let city: String?
    public let postCode: String?
    public let state: String?
    public let lat: String?
    public let long: String?
    public let address: String?
    public let country: String?
    public let googlePlaceName: String?
    public let areaOrDistrict: String?
    public let locality: String?
    
    enum CodingKeys: String, CodingKey {
        case addressLine1
        case addressLine2
        case addressArea
        case city
        case postCode
        case state
        case lat
        case long
        case address
        case country
        case googlePlaceName
        case areaOrDistrict
        case locality
    }
}

// MARK: - LogoImages
public struct LogoImages: Codable, Hashable {
    let logoImageMobile, logoImageThumb, logoImageweb: String?
    let logoMobileFilePath, profileimgeFilePath, twitterfilePath, opengraphfilePath: String?
    let logofilePath, facebookfilePath, socialgraphfilePath, logoFilePath: String?
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
