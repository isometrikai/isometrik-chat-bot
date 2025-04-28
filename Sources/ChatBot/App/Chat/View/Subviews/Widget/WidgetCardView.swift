//
//  WidgetView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 23/08/24.
//

import SwiftUI

struct IdentifiableImage: Identifiable, Hashable {
    let id = UUID()
    let image: Image
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: IdentifiableImage, rhs: IdentifiableImage) -> Bool {
        lhs.id == rhs.id
    }
}

struct WidgetCardView: View {
    
    // MARK: - PROPERTIES
    @Environment(\.customScheme) var colorScheme
    var appTheme: AppTheme
    var widgetData: ChatBotWidget?
    var type: WidgetType = .cardView
    var gptUIPreference: MyGptUIPreferences?
    var widgetTappedAction: ((ChatBotWidget?) -> Void)?
    
    // MARK: - BODY
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 0) {
                
                ZStack(alignment: .bottomTrailing) {
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                        URLImageView(url: getImageURL())
                            .scaledToFill()
                            .clipped()
                    }
                    .frame(height: 150)
                    
                    if type == .cardView {
                        getSupportedOrderTypeViews(orderType: widgetData?.supportedOrderTypes ?? 0)
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .clipped()
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top, spacing: 5, content: {
                        Text(getItemName())
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .font(.system(size: 14, weight: .bold))
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                    })
                    .padding(.bottom, 5)
                    
                    if type == .cardView, let distanceMiles = widgetData?.distanceMiles, let addressArea = widgetData?.address?.addressArea {
                        HStack {
                            HStack(spacing: 4) {
                                appTheme.theme.images.locationPin
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(.gray)
                                Text("\(addressArea) • \(distanceMiles, specifier: "%.1f") mi")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                        }
                        .padding(.bottom, 10)
                    }
                    
                    
                    
                    HStack(alignment: .top, spacing: 5, content: {
                        
                        
                        if type == .cardView, let currencyCode = widgetData?.currencyCode {
                            if let price = getPrice(), let originalPrice = getOriginalPrice() {
                                HStack(alignment: .top) {
                                    Text("\(currencyCode) \(price) for Two")
                                        .font(.system(size: 12))
                                        .foregroundStyle(colorScheme == .dark ? .white : .black.opacity(0.7))
                                        .layoutPriority(0) // Lower priority, can be compressed if needed
                                    
                                    Spacer(minLength: 8) // Ensure minimum spacing
                                    
                                    if type == .cardView, let storeTag = widgetData?.storeTag {
                                        let status = parseStoreTag(tag: storeTag)
                                        StatusBadgeView(status: status.status, opensAt: status.opensAt)
                                            .layoutPriority(1) // Higher priority to avoid truncation
                                    }
                                }
                                
                            }
                        } else {
                            if let price = getPrice() as? Double, let originalPrice = getOriginalPrice() as? Double, let currencyCode = widgetData?.currency{
                                Text("\(currencyCode) \(price, specifier: "%.2f")")
                                    .font(.system(size: 12))
                                    .foregroundStyle(colorScheme == .dark ? .white : .black.opacity(0.7))
                                if price != originalPrice {
                                    Text("\(currencyCode) \(originalPrice, specifier: "%.2f")")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Color.gray)
                                        .strikethrough()
                                }
                            }
                            
                            
                        }
                    })
                    
                    if let cuisineDetails = widgetData?.cuisineDetails {
                        Text(cuisineDetails)
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    
    //                if widgetData?.buttontext != nil {
    //                    self.getActionButton()
    //                }
    //                self.getActionButton()
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(appTheme.theme.colors.primaryBackgroundColor(for: colorScheme))
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            
            // Rating badge overlay at top-leading position
            if let averageRating = getAverageRating(), type == .cardView {
                RatingBadge(rating: averageRating)
                    .padding(8)
            }
        }
        
    }
    
    
    // MARK: - FUNCTIONS
    
    private func getImageURL() -> URL {
        let defaultURL = URL(string: "https://i.sstatic.net/frlIf.png")
        
        switch type {
        case .cardView:
            return URL(string: widgetData?.logoImages?.logoImageMobile ?? "") ?? defaultURL!
        case .productView:
            return URL(string: widgetData?.productImage ?? "") ?? defaultURL!
        default:
            return defaultURL!
        }
    }
    
    private func getItemName() -> String {
        switch type {
        case .cardView:
            return widgetData?.storename ?? "Store"
        case .productView:
            return widgetData?.productName ?? "Product"
        default:
            return "Item"
        }
    }
    
    private func getAverageRating() -> Double? {
        switch type {
        case .cardView:
            return widgetData?.avgRating
        case .productView:
            return widgetData?.averageRating
        default:
            return nil
        }
    }
    
    private func getPrice() -> Any? {
        switch type {
        case .cardView:
            return widgetData?.averageCostForMealForTwo
        case .productView:
            return widgetData?.finalPriceList?.finalPrice
        default:
            return nil
        }
    }
    
    private func getOriginalPrice() -> Any? {
        switch type {
        case .cardView:
            if let price = widgetData?.averageCostForMealForTwo {
                return price + 10
            }
            return nil
        case .productView:
            return widgetData?.finalPriceList?.basePrice
        default:
            return nil
        }
    }
                         
    func getDescriptionText() -> String {
        guard let widget = widgetData else {
            return "No data available"
        }
        
        let price = widget.price ?? "0.0"
        let averageCost = widget.averageCostForMealForTwo ?? 4
        let currencyCode = widget.currencyCode ?? "AED"
        let averageRating = String(format: "%.1f", widget.avgRating ?? 0)
        
        if averageCost != 0 {
            return "\(averageRating) ⭐ • \(currencyCode) \(averageCost) for two"
        }
        
        return price
    }
    
    func getSupportedOrderTypeViews(orderType: Int) -> some View {
        let orderTypes = SupportedOrderTypes(rawValue: orderType)
        let isTableReservation = widgetData?.tableReservations ?? false
        
        func createOrderTypeStack(_ images: [IdentifiableImage]) -> some View {
            HStack(spacing: 5) {
                ForEach(images) { identifiableImage in
                    OrderTypeView(image: identifiableImage.image)
                }
            }
            .padding(.vertical, orderTypes == .both ? 8 : 5)
            .padding(.horizontal, orderTypes == .both ? 8 : 10)
        }
        
        var images: [IdentifiableImage] = []
        
        switch orderTypes {
        case .delivery:
            images.append(IdentifiableImage(image: appTheme.theme.images.storeDelivery))
        case .selfPickup:
            images.append(IdentifiableImage(image: appTheme.theme.images.storePickup))
        case .both:
            images.append(contentsOf: [
                IdentifiableImage(image: appTheme.theme.images.storePickup),
                IdentifiableImage(image: appTheme.theme.images.storeDelivery)
            ])
        default:
            return AnyView(Circle().fill(.clear).frame(width: .zero, height: .zero))
        }
        
        if isTableReservation {
            images.append(IdentifiableImage(image: appTheme.theme.images.storeDinein))
        }
        
        return AnyView(createOrderTypeStack(images))
    }

    
//    func getActionButton() -> some View {
//        return AnyView(
//            Button {
//                widgetTappedAction?(widgetData)
//            } label: {
//                HStack {
//                    Spacer()
//                    Text(widgetData?.buttontext ?? "order now") // Fixed this line
//                        .font(.system(size: 14))
//                        .foregroundColor(Color(uiColor: UIColor(hex: gptUIPreference?.primaryColor ?? "")))
//                    Spacer()
//                }
//                .padding(.vertical, 10)
//                .padding(.horizontal, 16)
//                .overlay {
//                    getButtonOverlay(borderColor: .clear, backgroundColor: Color(uiColor: UIColor(hex: gptUIPreference?.primaryColor ?? "").withAlphaComponent(0.1)), radius: 6)
//                }
//            }
//            .cornerRadius(6)
//            .buttonStyle(AnimatedButtonStyle())
//            .contentShape(Rectangle())
//        )
//    }
    
}

struct RatingBadge: View {
    @Environment(\.customScheme) var colorScheme
    let rating: Double
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.system(size: 10))
            Text("\(rating, specifier: "%.1f")")
                .font(.system(size: 12))
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .clipShape(Capsule())
    }
}

// Status Badge View
struct StatusBadgeView: View {
    let status: String
    let opensAt: String
    
    var body: some View {
        HStack(spacing: 4) {
            switch status {
            case "open":
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("Open")
                    .foregroundColor(.green)
                    .lineLimit(1)
            case "closing-soon":
                Image(systemName: "clock.fill")
                    .foregroundColor(.orange)
                Text("Closing Soon")
                    .foregroundColor(.orange)
                    .lineLimit(1)
            case "opening-soon":
                Image(systemName: "clock.fill")
                    .foregroundColor(.blue)
                Text("Opens \(opensAt)")
                    .foregroundColor(.blue)
                    .lineLimit(1)
            case "closed":
                Image(systemName: "clock.fill")
                    .foregroundColor(.gray)
                Text("Opens \(opensAt)")
                    .foregroundColor(.gray)
                    .lineLimit(1)
            case "closed-today":
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                Text("Closed Today")
                    .foregroundColor(.red)
                    .lineLimit(1)
            default:
                EmptyView()
            }
        }
        .font(.system(size: 10, weight: .medium))
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(statusBackgroundColor)
        )
    }
    
    var statusBackgroundColor: Color {
        switch status {
        case "open":
            return Color.green.opacity(0.1)
        case "closing-soon":
            return Color.orange.opacity(0.1)
        case "opening-soon":
            return Color.blue.opacity(0.1)
        case "closed":
            return Color.gray.opacity(0.1)
        case "closed-today":
            return Color.red.opacity(0.1)
        default:
            return Color.clear
        }
    }
}

public func parseStoreTag(tag: String) -> (status: String, opensAt: String) {
    // Default values
    var status = "closed"
    var opensAt = ""
    
    // Clean the tag (remove quotes and potential JSON formatting)
    let cleanedTag = tag.replacingOccurrences(of: "\"store_tag\": ", with: "")
                        .replacingOccurrences(of: "\"", with: "")
    
    if cleanedTag.isEmpty {
        return (status, opensAt)
    }
    
    // Check for various status patterns
    if cleanedTag.lowercased().contains("open") {
        if cleanedTag.lowercased().contains("next at") || cleanedTag.lowercased().contains("opens at") {
            // Extract time for "Opens Next At XX:XX AM/PM" format
            if let timeRange = cleanedTag.range(of: #"\d{1,2}:\d{2} [AP]M"#, options: .regularExpression) {
                opensAt = String(cleanedTag[timeRange])
                status = "opening-soon"
            }
        } else if cleanedTag.lowercased().contains("open now") {
            status = "open"
        }
    } else if cleanedTag.lowercased().contains("closing") || cleanedTag.lowercased().contains("closes soon") {
        status = "closing-soon"
    } else if cleanedTag.lowercased().contains("closed") {
        if cleanedTag.lowercased().contains("today") {
            status = "closed-today"
        } else {
            status = "closed"
            
            // Try to extract the opening time if provided
            if let timeRange = cleanedTag.range(of: #"\d{1,2}:\d{2} [AP]M"#, options: .regularExpression) {
                opensAt = String(cleanedTag[timeRange])
            }
        }
    }
    
    return (status, opensAt)
}

//#Preview {
//    WidgetCardView(appTheme: AppTheme.init(theme: Theme.init()))
//        .previewLayout(.sizeThatFits)
//}

struct WidgetCardView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetCardView(appTheme: AppTheme(theme: Theme()))
            .previewLayout(.sizeThatFits)
            .frame(height: 300)
    }
}
