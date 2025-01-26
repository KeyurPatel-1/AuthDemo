//
//  CustomTextField.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import SwiftUI

struct CustomTextField: View {
    
    public struct Info {
        
        public enum Position: Hashable {  case top, error, success }
        
        var position: Position
        var text: String
        
        public init(position: Position, text: String) {
            self.position = position
            self.text = text
        }

        
    }
    
    var isSecure: Bool = false
    
    var binding: Binding<String>
    
    var placeHolder: String
    var infos: [Info] = []
    
    var leftView: AnyView? = nil
    var rightView: AnyView? = nil
    @FocusState var focused: Bool

    
    public init(
        binding: Binding<String>, placeHolder: String,
        infos: [Info],
        isSecure: Bool = false,
        leftView: AnyView? = nil, rightView: AnyView? = nil
    ) {
        self.isSecure = isSecure
        self.binding = binding
        self.placeHolder = placeHolder
        self.infos = infos
        self.leftView = leftView
        self.rightView = rightView
        
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            infoView()
                .zIndex(2.0)
            textField()
                .focused($focused)
            errorView()
            successView()
        }
    }
    
    
    @ViewBuilder
    func textField() -> some View {
        HStack {
            if let leftView = leftView {
                leftView
            }
            Group {
                if self.isSecure {
                    SecureField(placeHolder, text: binding)
                } else {
                    TextField(placeHolder, text: binding)
                }
            }
            if let rightView = rightView {
                rightView
            }
        }
        .frame(height: 48)
        .padding(.horizontal,16)
        .foregroundStyle(Color.primaryTextColor)
        .font(.system(size: 14, weight: .semibold, design: .default))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.secondaryTextColor, lineWidth: 1)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
        )
    }
    
    @ViewBuilder
    func infoView() -> some View {
        self.infos.filter { $0.position == .top }
            .first.convertToView { info in
                HStack {
                    Spacer().frame(width: 6)
                    
                    HStack{
                        Text(info.text)
                            .font(.system(size: 14, weight: .semibold, design: .default))
                            .foregroundColor(Color.secondaryTextColor)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
            }
    }
    
    @ViewBuilder
    func errorView() -> some View {
        self.infos.filter { $0.position == .error }
            .first.convertToView { info in
                HStack {
                    
                    Spacer().frame(width: 2)
                    
                    Image(.errorInfoTextField)
                    
                    Spacer().frame(width: 6)
                    
                    Text(info.text)
                        .font(.system(size: 14, weight: .semibold, design: .default))
                        .foregroundColor(Color.errorColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
            }
    }
    
    @ViewBuilder
    func successView() -> some View {
        self.infos.filter { $0.position == .success }
            .first.convertToView { info in
                HStack {
                    
                    Spacer().frame(width: 2)
                    
                    Image(.icSuccessColored)
                    
                    Spacer().frame(width: 6)
                    
                    Text(info.text)
                        .font(.system(size: 14, weight: .semibold, design: .default))
                        .foregroundColor(Color.primaryColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
            }
    }
}
