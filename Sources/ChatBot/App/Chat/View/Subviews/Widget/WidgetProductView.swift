//
//  WidgetProductView.swift
//  ChatBot
//
//  Created by Nikunj's M1 on 29/04/25.
//

import SwiftUI

struct WidgetProductView: View {
    
    @Environment(\.customScheme) var colorScheme
    var appTheme: AppTheme
    var widgetData: ChatBotWidget?
    var gptUIPreference: MyGptUIPreferences?

    var widgetTappedAction: ((ChatBotWidget?) -> Void)?
    
    var body: some View {
        Button {
            widgetTappedAction?(widgetData)
        } label: {
            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    ZStack(alignment: .bottomTrailing) {
                        ZStack(alignment: .center) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                            URLImageView(url: getImageURL())
                                .scaledToFill()
                                .clipped()
                                .frame(width: 180, height: 200)
                                .overlay(alignment: .bottomLeading) {
                                    // Rating badge overlay at top-leading position
                                    if let averageRating = getAverageRating() {
                                        RatingBadge(rating: averageRating)
                                            .padding(8)
                                    }
                                }
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
                        
                        
                        HStack(alignment: .top, spacing: 5, content: {
                            
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
                        })
                        
                        Text("ORDER NOW")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color(hex: "#007AFF"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: "#007AFF").opacity(0.1))
                            )
                            .padding(8)
                        
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
        }

        
    }
    
    // MARK: - FUNCTIONS
    
    private func getImageURL() -> URL {
        let defaultURL = URL(string: "https://i.sstatic.net/frlIf.png")
        
        return URL(string: widgetData?.productImage ?? "") ?? defaultURL!
    }
    
    private func getItemName() -> String {
        return widgetData?.productName ?? "Product"
    }
    
    private func getAverageRating() -> Double? {
        return widgetData?.averageRating
    }
    
    private func getPrice() -> Any? {
        return widgetData?.finalPriceList?.finalPrice
    }
    
    private func getOriginalPrice() -> Any? {
        return widgetData?.finalPriceList?.basePrice
    }
                         
}
