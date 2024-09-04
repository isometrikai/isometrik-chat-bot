//
//  SuggestedRepliesView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 25/08/24.
//

import SwiftUI

struct SuggestedRepliesView: View {
    
    // MARK: - PROPERTIES
    
    var replies: [String] = []
    var uiPreference: MyGptUIPreferences?
    var replyAction: (String) -> Void
    
    
    // MARK: - BODY
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            ForEach(replies, id: \.self) { reply in
                
                Button {
                    replyAction(reply)
                } label: {
                    Text(reply)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: uiPreference?.primaryColor ?? ""))
                        .overlay {
                            getButtonOverlay()
                        }
                        .padding(.top, 8)
                }
                .buttonStyle(AnimatedButtonStyle())
            }
        } //: LazyVStack
    } //: BODY
    
    // MARK: - FUNCTIONS
    func getButtonOverlay() -> some View {
        Group {
            if #available(iOS 17.0, *) {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color(hex: uiPreference?.primaryColor ?? ""), lineWidth: 1)
                    .background(Color.clear)
            } else {
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke(Color(hex: uiPreference?.primaryColor ?? ""), lineWidth: 1)
            }
        }
    }
    
}

#Preview {
    SuggestedRepliesView(replies: ["Want to eat something", "show me all my favorite stores"]) { reply in
        print(reply)
    }
}
