import Foundation
import SwiftUI

final class AppData: ObservableObject {

    @Published var categories: [BudgetCategory] = [
        BudgetCategory(name: "Food", icon: "fork.knife", color: "green", monthlyBudget: 400),
        BudgetCategory(name: "Rent", icon: "house.fill", color: "blue", monthlyBudget: 1200),
        BudgetCategory(name: "Shopping", icon: "bag.fill", color: "pink", monthlyBudget: 250),
        BudgetCategory(name: "Transport", icon: "car.fill", color: "orange", monthlyBudget: 150),
        BudgetCategory(name: "Savings", icon: "banknote.fill", color: "teal", monthlyBudget: 500),
        BudgetCategory(name: "Other", icon: "square.grid.2x2.fill", color: "gray", monthlyBudget: 100)
    ]

    func category(for id: UUID) -> BudgetCategory? {
        categories.first { $0.id == id }
    }

    func addCategory(
        name: String,
        icon: String = "square.grid.2x2.fill",
        color: String = "gray",
        monthlyBudget: Double = 0
    ) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let newCategory = BudgetCategory(
            name: trimmed,
            icon: icon,
            color: color,
            monthlyBudget: monthlyBudget
        )

        categories.append(newCategory)
    }

    func deleteCategory(_ category: BudgetCategory) {
        categories.removeAll { $0.id == category.id }
    }

    func updateMonthlyBudget(for categoryId: UUID, to newBudget: Double) {
        guard let index = categories.firstIndex(where: { $0.id == categoryId }) else { return }
        categories[index].monthlyBudget = max(0, newBudget)
    }
}
