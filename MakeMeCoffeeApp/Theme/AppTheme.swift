import SwiftUI

struct AppTheme {
    struct Colors {
        static let background = Color.black
        static let cardBackground = Color.white.opacity(0.03)
        static let cardBorder = Color.white.opacity(0.1)
        static let primaryText = Color.white
        static let secondaryText = Color.white.opacity(0.7)
        
        struct Gradient {
            static let purple = LinearGradient(
                colors: [Color(hex: "B06AB3"), Color(hex: "4568DC")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            static let blue = LinearGradient(
                colors: [Color(hex: "4568DC"), Color(hex: "00F2FE")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            static let green = LinearGradient(
                colors: [Color(hex: "11998E"), Color(hex: "38EF7D")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        struct Card {
            static let shadow = Color.black.opacity(0.3)
            static let overlay = Color.white.opacity(0.1)
        }
    }
    
    struct Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 20
        static let extraLarge: CGFloat = 32
    }
    
    struct Radius {
        static let small: CGFloat = 12
        static let medium: CGFloat = 16
        static let large: CGFloat = 20
        static let extraLarge: CGFloat = 24
    }
    
    struct Animations {
        static let springResponse: Double = 0.35
        static let springDamping: Double = 0.65
        
        static func spring(response: Double = springResponse, 
                         damping: Double = springDamping) -> Animation {
            .spring(response: response, dampingFraction: damping)
        }
        
        static let easeInOut = Animation.easeInOut(duration: 0.3)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 