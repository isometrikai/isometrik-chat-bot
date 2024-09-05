//
//  LoaderView.swift
//  ChatBot
//
//  Created by Appscrip 3Embed on 28/08/24.
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
            Text("Preparing your chat experience...")
                .font(.headline)
        }
    }
}

#Preview {
    LoaderView()
}
