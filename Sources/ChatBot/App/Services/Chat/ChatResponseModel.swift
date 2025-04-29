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
    
    func getCardWidget() -> [ChatBotWidget]? {
        var allChatBotWidgets: [ChatBotWidget] = []
        
        guard let widgetData else {return []}
        // Loop through each element in widgetData
        for dataElement in widgetData {
            if let widgetUnions = dataElement.widget {
                // Extract ChatBotWidget cases and add to our array
                for widgetUnion in widgetUnions {
                    if case .widgetClass(let chatBotWidget) = widgetUnion {
                        allChatBotWidgets.append(chatBotWidget)
                    }
                }
            }
        }
        
        // Return nil if no ChatBotWidget found, otherwise return the array
        return allChatBotWidgets.isEmpty ? nil : allChatBotWidgets
    }
    
    func getOptionsWidget() -> [String]? {
        var allChatBotWidgets: [String] = []
        
        guard let widgetData else {return []}
        
        // Loop through each element in widgetData
        for dataElement in widgetData {
            if let widgetUnions = dataElement.widget {
                // Extract ChatBotWidget cases and add to our array
                for widgetUnion in widgetUnions {
                    if case .string(let chatBotWidget) = widgetUnion {
                        allChatBotWidgets.append(chatBotWidget)
                    }
                }
            }
        }
        
        // Return nil if no ChatBotWidget found, otherwise return the array
        return allChatBotWidgets.isEmpty ? nil : allChatBotWidgets
    }
    
}

public struct WidgetData: Codable, Hashable {
    
    public let widgetId: Int?
    public let type: String?
    public let widget: [WidgetUnion]?
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
        self.widget = try container.decodeIfPresent([WidgetUnion].self, forKey: .widget)
    }
}

public enum WidgetUnion: Codable, Hashable {
    case string(String)
    case widgetClass(ChatBotWidget)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(ChatBotWidget.self) {
            self = .widgetClass(x)
            return
        }
        throw DecodingError.typeMismatch(WidgetUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for WidgetUnion"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .widgetClass(let x):
            try container.encode(x)
        }
    }
}

public struct ChatBotWidget: Codable, Hashable {
    
    // Stores
    
    public var id, storename: String?
    public var avgRating: Double?
    public var storeIsOpen: Bool?
    public var storeTag: String?
    public var logoImages: LogoImages?
    public var isTempClose: Bool?
    public var address: StoreAddress?
    public var cuisineDetails: String?
    public var storeImage: String?
    public var distanceKM, distanceMiles: Double?
    public var tableReservations: Bool?
    public var supportedOrderTypes, averageCostForMealForTwo: Int?
    public var currencyCode: String?
    public var currencySymbol: String?
    public var price: String?
    
    // Products
    public var productName: String?
    public var finalPrice: Double?
    public var inStock: Bool?
    public var tag: Int?
    public var finalPriceList: FinalPriceList?
    public var productImage: String?
    public var averageRating: Double?
    public var currency: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case storename
        case avgRating
        case storeIsOpen = "store_is_open"
        case storeTag = "store_tag"
        case logoImages
        case isTempClose = "is_temp_close"
        case address
        case cuisineDetails
        case storeImage
        case distanceKM = "distance_km"
        case distanceMiles = "distance_miles"
        case tableReservations
        case supportedOrderTypes
        case averageCostForMealForTwo
        case currencyCode
        case currencySymbol
        case price
        case productName
        case finalPrice
        case inStock
        case tag
        case finalPriceList
        case productImage = "product_image"
        case averageRating = "average_rating"
        case currency
        
    }
    
    public init(id: String? = nil,
                storename: String? = nil,
                avgRating: Double? = nil,
                storeIsOpen: Bool? = nil,
                storeTag: String? = nil,
                logoImages: LogoImages? = nil,
                isTempClose: Bool? = nil,
                address: StoreAddress? = nil,
                cuisineDetails: String? = nil,
                storeImage: String? = nil,
                distanceKM: Double? = nil,
                distanceMiles: Double? = nil,
                tableReservations: Bool? = nil,
                supportedOrderTypes: Int? = nil,
                averageCostForMealForTwo: Int? = nil,
                currencyCode: String? = nil,
                currencySymbol: String? = nil,
                price: String? = nil,
                productName: String? = nil,
                finalPrice: Double? = nil,
                inStock: Bool? = nil,
                tag: Int? = nil,
                finalPriceList: FinalPriceList? = nil,
                productImage: String? = nil,
                averageRating: Double? = nil,
                currency: String? = nil) {
        self.id = id
        self.storename = storename
        self.avgRating = avgRating
        self.storeIsOpen = storeIsOpen
        self.storeTag = storeTag
        self.logoImages = logoImages
        self.isTempClose = isTempClose
        self.address = address
        self.cuisineDetails = cuisineDetails
        self.storeImage = storeImage
        self.distanceKM = distanceKM
        self.distanceMiles = distanceMiles
        self.tableReservations = tableReservations
        self.supportedOrderTypes = supportedOrderTypes
        self.averageCostForMealForTwo = averageCostForMealForTwo
        self.currencyCode = currencyCode
        self.currencySymbol = currencySymbol
        self.price = price
        self.productName = productName
        self.finalPrice = finalPrice
        self.inStock = inStock
        self.tag = tag
        self.finalPriceList = finalPriceList
        self.productImage = productImage
        self.averageRating = averageRating
        self.currency = currency
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
        self.cuisineDetails = try container.decodeIfPresent(String.self, forKey: .cuisineDetails)
        self.storeImage = try container.decodeIfPresent(String.self, forKey: .storeImage)
        self.distanceKM = try container.decodeIfPresent(Double.self, forKey: .distanceKM)
        self.distanceMiles = try container.decodeIfPresent(Double.self, forKey: .distanceMiles)
        self.tableReservations = try container.decodeIfPresent(Bool.self, forKey: .tableReservations)
        self.supportedOrderTypes = try container.decodeIfPresent(Int.self, forKey: .supportedOrderTypes)
        self.averageCostForMealForTwo = try container.decodeIfPresent(Int.self, forKey: .averageCostForMealForTwo)
        self.currencyCode = try container.decodeIfPresent(String.self, forKey: .currencyCode)
        self.currencySymbol = try container.decodeIfPresent(String.self, forKey: .currencySymbol)
        self.price = try container.decodeIfPresent(String.self, forKey: .price)
        self.productName = try container.decodeIfPresent(String.self, forKey: .productName)
        self.finalPrice = try container.decodeIfPresent(Double.self, forKey: .finalPrice)
        self.inStock = try container.decodeIfPresent(Bool.self, forKey: .inStock)
        self.tag = try container.decodeIfPresent(Int.self, forKey: .tag)
        self.finalPriceList = try container.decodeIfPresent(FinalPriceList.self, forKey: .finalPriceList)
        self.productImage = try container.decodeIfPresent(String.self, forKey: .productImage)
        self.averageRating = try container.decodeIfPresent(Double.self, forKey: .averageRating)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency)
    }
}

enum OfferTypeDiscount: Int, Codable, Hashable {
    case flatDiscount = 0
    case percentageDiscount = 1
    case combo = 2
}

public struct FinalPriceList:Codable,Hashable{
    let finalPrice:Double?
    let discountPercentage:Int?
    let basePrice:Double?
    let discountPrice:Double?
    let sellerPrice:Double?
    var msrpPrice: Double?
    let discount : Double?
    let taxRate : Double?
    var discountType: OfferTypeDiscount?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        finalPrice = try container.decodeIfPresent(Double.self, forKey: .finalPrice)
        discountPercentage = try? container.decodeIfPresent(Int.self, forKey: .discountPercentage)
        basePrice = try container.decodeIfPresent(Double.self, forKey: .basePrice)
        discountPrice = try container.decodeIfPresent(Double.self, forKey: .discountPrice)
        sellerPrice = try? container.decodeIfPresent(Double.self, forKey: .sellerPrice)
        msrpPrice = try? container.decodeIfPresent(Double.self, forKey: .msrpPrice)
        discount = try? container.decodeIfPresent(Double.self, forKey: .discount)
        discountType = try? container.decodeIfPresent(OfferTypeDiscount.self, forKey: .discountType)
        if msrpPrice == nil{
            msrpPrice = basePrice
        }
        taxRate = try? container.decodeIfPresent(Double.self, forKey: .taxRate)
    }
}

public struct StoreAddress: Codable, Hashable {
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
