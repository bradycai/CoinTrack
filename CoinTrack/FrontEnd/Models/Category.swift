import Foundation

struct BudgetCategory: Identifiable, Codable, Hashable {

    let id: UUID
    var name: String
    var icon: String
    var color: String
    var monthlyBudget: Double

    init(
        id: UUID = UUID(),
        name: String,
        icon: String,
        color: String,
        monthlyBudget: Double = 0
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.monthlyBudget = monthlyBudget
    }
}
