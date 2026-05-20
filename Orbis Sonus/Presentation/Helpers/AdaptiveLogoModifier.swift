//
//  AdaptiveLogoModifier.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 25/4/26.
//


import SwiftUI

struct AdaptiveLogoModifier: ViewModifier {
    @Environment(\.sizeCategory) private var sizeCategory
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .title) {
                    Image(.navigationLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(height: logoHeight)
                        .padding(.vertical, 4)
                        .clipped()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private var logoHeight: CGFloat {
        return switch sizeCategory {
        case .extraSmall, .small, .medium: 28
        case .large: 32
        case .extraLarge, .extraExtraLarge, .extraExtraExtraLarge: 36
        default: 40
        }
    }
}

extension View {
    func adaptiveLogo(baseHeight: CGFloat = 28) -> some View {
        self.modifier(AdaptiveLogoModifier())
    }
}

struct GlassModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(.clear, in: Rectangle())
        } else {
            content
                .background(Color.white.opacity(0.4))
        }
    }
}
extension View {
    func glassModifier() -> some View {
        self.modifier(GlassModifier())
    }
}
