//
//  OrderTypeView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 28/08/24.
//

import SwiftUI

struct OrderTypeView: View {
    
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .foregroundColor(.red)
            .scaledToFit()
            .frame(width: 40, height: 40)
            .cornerRadius(15)
            .overlay {
                Circle()
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
            }
    }
}

#Preview {
    OrderTypeView(image: Image("ic_pickup"))
}
