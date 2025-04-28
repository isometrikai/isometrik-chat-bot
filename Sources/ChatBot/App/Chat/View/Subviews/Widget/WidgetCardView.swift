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
            
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 5, content: {
                    Text(getItemName())
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .font(.system(size: 14))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    if let averageRating = getAverageRating() {
                        Text("⭐ \(averageRating, specifier: "%.1f")")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .font(.system(size: 14))
                    }
                    
                })
                
                HStack(alignment: .top, spacing: 5, content: {
                    
                    
                    if type == .cardView, let currencyCode = widgetData?.currencyCode {
                        if let price = getPrice(), let originalPrice = getOriginalPrice() {
                            Text("\(currencyCode) \(price)")
                                .font(.system(.subheadline))
                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                            Text("\(currencyCode) \(originalPrice)")
                                .font(.system(.subheadline))
                                .foregroundStyle(Color.gray)
                                .strikethrough()
                        }
                    } else {
                        if let price = getPrice() as? Double, let originalPrice = getOriginalPrice() as? Double, let currencyCode = widgetData?.currency{
                            Text("\(currencyCode) \(price, specifier: "%.2f")")
                                .font(.system(.subheadline))
                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                            Text("\(currencyCode) \(originalPrice, specifier: "%.2f")")
                                .font(.system(.subheadline))
                                .foregroundStyle(Color.gray)
                                .strikethrough()
                        }
                        
                        
                    }
                })
                
                if type == .cardView, let distanceMiles = widgetData?.distanceMiles {
                    Text("\(distanceMiles, specifier: "%.2f") Miles away")
                        .font(.system(.caption))
                        .foregroundColor(Color.white)
                }
                
                if type == .cardView, let storeTag = widgetData?.storeTag {
                    Text(storeTag)
                        .font(.system(.caption))
                        .foregroundColor(Color.red)
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
