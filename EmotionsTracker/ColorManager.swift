import Foundation
import SwiftUI

struct ColorManager {
    static func colorFromIndex(index: Int) -> Color {
        switch index {
        case 1: return .blue
        case 2: return .black
        case 3: return .cyan
        case 4: return .gray
        case 5: return .green
        case 6: return .indigo
        case 7: return .mint
        case 8: return .orange
        case 9: return .pink
        case 10: return .purple
        case 11: return .red
        case 12: return .teal
        default: return .blue
        }
    }
    
    static func nameFromIndex(index: Int) -> String {
        switch index {
        case 1: return "blue"
        case 2: return "black"
        case 3: return "cyan"
        case 4: return "gray"
        case 5: return "green"
        case 6: return "indigo"
        case 7: return "mint"
        case 8: return "orange"
        case 9: return "pink"
        case 10: return "purple"
        case 11: return "red"
        case 12: return "teal"
        default: return "blue"
        }
    }
}
