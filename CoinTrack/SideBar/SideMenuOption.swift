import SwiftUI

enum SideMenuOption: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case history = "History"
    case categories = "Categories"
    case settings = "Settings"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .dashboard: return "house"
        case .history: return "clock.arrow.circlepath"
        case .categories: return "chart.pie"
        case .settings: return "gearshape"
        }
    }
}
