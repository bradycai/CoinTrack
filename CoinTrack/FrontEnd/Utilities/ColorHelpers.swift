import SwiftUI

func colorFromName(_ name: String) -> Color {
    switch name.lowercased() {
    case "green":
        return .green
    case "blue":
        return .blue
    case "pink":
        return .pink
    case "orange":
        return .orange
    case "teal":
        return .teal
    case "red":
        return .red
    case "purple":
        return .purple
    case "gray":
        return .gray
    default:
        return .gray
    }
}
