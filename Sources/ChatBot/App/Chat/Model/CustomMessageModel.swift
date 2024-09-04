//
//  CustomMessageModel.swift
//  
//
//  Created by Appscrip 3Embed on 04/09/24.
//

import Foundation

public enum SupportedOrderTypes: Int {
    case delivery = 2
    case selfPickup = 1
    case both = 3
}

public struct CustomMessageModel: Identifiable, Equatable {
    
    public let id = UUID()
    public var text: String
    public let isFromUser: Bool
    public var isResponding: Bool = false
    public var messageData: GptClientResponseModel? = nil
    private var currentTaskId: UUID?

    init(text: String, isFromUser: Bool) {
        self.text = text
        self.isFromUser = isFromUser
    }

    init() {
        self.text = "Thinking.."
        self.isFromUser = false
        self.isResponding = true
    }
    
    public static func == (lhs: CustomMessageModel, rhs: CustomMessageModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.isFromUser == rhs.isFromUser &&
        lhs.isResponding == rhs.isResponding
    }
    
}
