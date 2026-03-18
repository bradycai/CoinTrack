import SwiftUI

enum SideMenuOption: String, CaseIterable, Identifiable {
    case home = "Home"
    case dashboard = "Dashboard"
    case addTransaction = "Add Transaction"
    case history = "History"
    case categories = "Categories"
    case analytics = "Analytics"
    case settings = "Settings"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .home:
            return "house"
        case .dashboard:
            return "creditcard"
        case .addTransaction:
            return "plus.circle"
        case .history:
            return "clock.arrow.circlepath"
        case .categories:
            return "chart.pie"
        case .analytics:
            return "chart.bar"
        case .settings:
            return "gearshape"
        }
    }
}
