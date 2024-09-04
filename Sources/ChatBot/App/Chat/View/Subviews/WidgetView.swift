//
//  WidgetView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import SwiftUI

struct WidgetView: View {
    
    // MARK: - PROPERTIES
    var appTheme: AppTheme
    var widgetData: Widget?
    var widgetTappedAction: ((Widget?) -> Void)?
    
    // MARK: - BODY
    
    var body: some View {
        Button {
            widgetTappedAction?(widgetData)
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomTrailing) {
                    URLImageView(url: URL(string: widgetData?.imageURL ?? "")!)
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                    
                    getSupportedOrderTypeViews(orderType: widgetData?.supportedOrderTypes ?? 0)
                }
                VStack(alignment: .leading) {
                    Text(widgetData?.title ?? "")
                        .font(.system(size: 14))
                    Text(widgetData?.subtitle ?? "")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#94A0AF"))
                    Text(getDescriptionText())
                        .font(.system(size: 14))
                        .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
            }
            .frame(width: 250)
            .background(Color(hex: "#F6F6F6"))
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(hex: "#F6F6F6"), lineWidth: 2)
            )
        }
        .buttonStyle(AnimatedButtonStyle())
    }
    
    
    // MARK: - FUNCTIONS
                         
    func getDescriptionText() -> String {
        let price = widgetData?.price ?? ""
        let averageCost = widgetData?.averageCost ?? 0
        let currencyCode = widgetData?.currencyCode ?? ""
        let averageRating = widgetData?.averageRating ?? 0
        
        if averageCost != 0 {
            return "\(averageRating) ⭐ • \(currencyCode) \(averageCost) for two"
        }
        
        return price
    }
    
    func getSupportedOrderTypeViews(orderType: Int) -> some View {
        
        let orderTypes = SupportedOrderTypes(rawValue: orderType)
        let isTableReservation = widgetData?.tableReservations ?? false
        
        switch orderTypes {
        case .delivery:
            return AnyView(
                HStack(spacing: 5) {
                    OrderTypeView(image: appTheme.theme.images.storeDelivery)
                    if isTableReservation {
                        OrderTypeView(image: appTheme.theme.images.storeDinein)
                    }
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
            )
        case .selfPickup:
            return AnyView(
                HStack(spacing: 5) {
                    OrderTypeView(image: appTheme.theme.images.storePickup)
                    if isTableReservation {
                        OrderTypeView(image: appTheme.theme.images.storeDinein)
                    }
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
            )
        case .both:
            return AnyView(
                HStack(spacing: 5) {
                    OrderTypeView(image: appTheme.theme.images.storePickup)
                    OrderTypeView(image: appTheme.theme.images.storeDelivery)
                    if isTableReservation {
                        OrderTypeView(image: appTheme.theme.images.storeDinein)
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
            )
        default:
            return AnyView(Circle().fill(.clear).frame(width: .zero, height: .zero))
        }
        
    }
    
}
