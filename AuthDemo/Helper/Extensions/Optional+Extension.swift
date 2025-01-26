//
//  Optional+Extension.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import SwiftUI

extension Optional {
    
    @ViewBuilder
    func convertToView(@ViewBuilder block: (Wrapped) -> some View) -> some View {
        if let unwrapped = self {
            block(unwrapped)
        }
    }
}
