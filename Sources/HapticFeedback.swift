//
//  HapticFeedback.swift
//  Gym Fit
//
//  Created by Pragyat Agrawal on 11/12/25.
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

// Helper for haptic feedback
enum HapticStyle {
    case light
    case medium
    case heavy
    
    #if os(iOS)
    var uiStyle: UIImpactFeedbackGenerator.FeedbackStyle {
        switch self {
        case .light: return .light
        case .medium: return .medium
        case .heavy: return .heavy
        }
    }
    #endif
}

enum HapticNotificationType {
    case success
    case warning
    case error
    
    #if os(iOS)
    var uiType: UINotificationFeedbackGenerator.FeedbackType {
        switch self {
        case .success: return .success
        case .warning: return .warning
        case .error: return .error
        }
    }
    #endif
}

struct HapticFeedback {
    static func impact(style: HapticStyle = .medium) {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: style.uiStyle)
        generator.impactOccurred()
        #endif
    }
    
    static func selection() {
        #if os(iOS)
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        #endif
    }
    
    static func notification(type: HapticNotificationType) {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type.uiType)
        #endif
    }
}

