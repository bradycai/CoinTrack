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
    ] {
        didSet { save() }
    }

    @Published var transactions: [Transaction] = [] {
        didSet { save() }
    }

    private let key = "cointrack_appdata_v2"

    init() {
        load()
    }

    // MARK: - Computed Totals

    var balance: Double {
        totalIncome - totalExpenses
    }

    var totalIncome: Double {
        transactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }

    var totalExpenses: Double {
        transactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }

    var thisMonthIncome: Double {
        transactions
            .filter {
                $0.type == .income &&
                Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .month)
            }
            .reduce(0) { $0 + $1.amount }
    }

    var thisMonthExpenses: Double {
        transactions
            .filter {
                $0.type == .expense &&
                Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .month)
            }
            .reduce(0) { $0 + $1.amount }
    }

    // MARK: - Category Helpers

    func transactions(for category: BudgetCategory) -> [Transaction] {
        transactions.filter { $0.categoryId == category.id }
    }

    func spentAmount(for category: BudgetCategory) -> Double {
        transactions
            .filter {
                $0.categoryId == category.id &&
                $0.type == .expense &&
                Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .month)
            }
            .reduce(0) { $0 + $1.amount }
    }

    func remainingBudget(for category: BudgetCategory) -> Double {
        category.monthlyBudget - spentAmount(for: category)
    }

    func budgetProgress(for category: BudgetCategory) -> Double {
        guard category.monthlyBudget > 0 else { return 0 }
        return min(spentAmount(for: category) / category.monthlyBudget, 1.0)
    }

    func category(for id: UUID) -> BudgetCategory? {
        categories.first { $0.id == id }
    }

    // MARK: - Mutating Actions

    func addTransaction(_ transaction: Transaction) {
        transactions.insert(transaction, at: 0)
    }

    func deleteTransaction(at offsets: IndexSet) {
        transactions.remove(atOffsets: offsets)
    }

    func addCategory(name: String, icon: String = "square.grid.2x2.fill", color: String = "gray", monthlyBudget: Double = 0) {
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
        transactions.removeAll { $0.categoryId == category.id }
    }

    func updateMonthlyBudget(for categoryId: UUID, to newBudget: Double) {
        guard let index = categories.firstIndex(where: { $0.id == categoryId }) else { return }
        categories[index].monthlyBudget = max(0, newBudget)
    }

    // MARK: - Persistence

    private func save() {
        let payload = Persisted(categories: categories, transactions: transactions)
        guard let data = try? JSONEncoder().encode(payload) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let payload = try? JSONDecoder().decode(Persisted.self, from: data) else {
            return
        }

        self.categories = payload.categories
        self.transactions = payload.transactions
    }

    private struct Persisted: Codable {
        var categories: [BudgetCategory]
        var transactions: [Transaction]
    }
}
