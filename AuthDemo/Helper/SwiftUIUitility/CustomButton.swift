//
//  CustomButton.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import SwiftUI

struct CustomButton: View {
    
    let title: String
    let backgroundColor: Color
    var isLoading: Bool
    var isDisable: Bool
    let action: (() -> Void)?
    
    var body: some View {
        Button {
            action?()
        } label: {
            if isLoading {
                ProgressView()
            } else {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
            
        }
        .padding()
        .background((isLoading || isDisable) ? backgroundColor.opacity(0.5) : backgroundColor)
        .disabled(isDisable || isLoading)
        .overlay {
            Capsule(style: .continuous)
                .stroke(.clear, lineWidth: 1)
        }
        .clipShape(
            Capsule(style: .continuous)
        )
    }
}

#Preview {
    CustomButton(title: "Button", backgroundColor: .red, isLoading: true, isDisable: false) {
        
    }
}
