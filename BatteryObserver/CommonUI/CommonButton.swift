//
//  File.swift
//  BatteryObserver
//
//  Created by Bohdan Bondar on 10.08.2025
//
//

import SwiftUI

struct CommonButton<Content: View>: View {
    let content: () -> Content
    let action: () -> Void
    
    init(
        content: @escaping () -> Content,
        action: @escaping () -> Void
    ) {
        self.content = content
        self.action = action
    }
    
    var body: some View {
        Button(action: action, label: content)
            .buttonStyle(CommonButtonStyle())
    }
}

private struct CommonButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.blue)
            .clipShape(.rect(cornerRadius: 20))
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}
