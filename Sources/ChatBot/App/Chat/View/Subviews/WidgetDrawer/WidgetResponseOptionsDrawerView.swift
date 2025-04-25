

import SwiftUI

struct WidgetResponseOptionsDrawerView: View {
    
    // MARK: - PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.customScheme) var colorScheme
    var title: String
    var options: [String]
    var appTheme: AppTheme
    var gptUIPreference: MyGptUIPreferences?
    var responseCallback: ((String?)->Void)?
    
    // MARK: - BODY
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(appTheme.theme.colors.secondaryBackgroundColor(for: colorScheme))
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                
                Text("What types of cuisine do you enjoy?")
                    .foregroundColor(appTheme.theme.colors.primaryColor(for: colorScheme))
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.horizontal, 16)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(options, id: \.self) { option in
                            Button {
                                responseCallback?(option)
                                dismiss()
                            } label: {
                                Text(option)
                                    .font(.system(size: 14))
                                    .foregroundColor(appTheme.theme.colors.primaryColor(for: colorScheme))
                                    .frame(height: 50)
                                    .padding(.horizontal, 16)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .background(appTheme.theme.colors.primaryBackgroundColor(for: colorScheme))
                                    .cornerRadius(10)
                                    .overlay {
                                        RoundedCorner(topLeft: 8, topRight: 8, bottomLeft: 8, bottomRight: 8)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    }
                            }
                            .padding(.horizontal, 16)
                            .buttonStyle(AnimatedButtonStyle())
                            .contentShape(Rectangle())
                        }
                    }
                } //: SCROLLVIEW
                .customContentMargins(bottom: 50)
                
                Spacer()
            } //: VSTACK
            .edgesIgnoringSafeArea(.all)
        }
        
    }
    
}
