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
    var gptUIPreference: MyGptUIPreferences?
    var widgetTappedAction: ((ChatBotWidget?) -> Void)?
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            ZStack(alignment: .bottomTrailing) {
                ZStack(alignment: .center) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                    URLImageView(url: URL(string: widgetData?.imageURL ?? "") ?? URL(string: "https://i.sstatic.net/frlIf.png"))
                        .scaledToFill()
                        .clipped()
                }
                .frame(height: 150)
                getSupportedOrderTypeViews(orderType: widgetData?.supportedOrderTypes ?? 0)
            }
            .frame(maxWidth: .infinity)
            .clipped()
            
            VStack(alignment: .leading) {
                Text(widgetData?.title ?? "title")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                Text(widgetData?.subtitle ?? "subtitle")
                    .font(.system(size: 12))
                    .foregroundColor(Color(uiColor: UIColor(hex: "#94A0AF")))
                Text(getDescriptionText())
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.system(size: 14))
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                Spacer()
                if widgetData?.buttontext != nil {
                    self.getActionButton()
                }
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
                         
    func getDescriptionText() -> String {
        guard let widget = widgetData else {
            return "No data available"
        }
        
        let price = widget.price ?? "0.0"
        let averageCost = widget.averageCost ?? 4
        let currencyCode = widget.currencyCode ?? "AED"
        let averageRating = String(format: "%.1f", widget.averageRating ?? 0)
        
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

    
    func getActionButton() -> some View {
        return AnyView(
            Button {
                widgetTappedAction?(widgetData)
            } label: {
                HStack {
                    Spacer()
                    Text(widgetData?.buttontext ?? "order now") // Fixed this line
                        .font(.system(size: 14))
                        .foregroundColor(Color(uiColor: UIColor(hex: gptUIPreference?.primaryColor ?? "")))
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .overlay {
                    getButtonOverlay(borderColor: .clear, backgroundColor: Color(uiColor: UIColor(hex: gptUIPreference?.primaryColor ?? "").withAlphaComponent(0.1)), radius: 6)
                }
            }
            .cornerRadius(6)
            .buttonStyle(AnimatedButtonStyle())
            .contentShape(Rectangle())
        )
    }
    
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
