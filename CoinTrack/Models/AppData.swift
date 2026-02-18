import Foundation

final class AppData: ObservableObject {

    @Published var balance: Double = 0.0 { didSet { save() } }
    @Published var categories: [Category] = [
        Category(name: "Food"),
        Category(name: "Leisure"),
        Category(name: "Savings"),
        Category(name: "Other")
    ] { didSet { save() } }

    @Published var history: [Transaction] = [] { didSet { save() } }

    private let key = "cointrack_appdata_v1"

    init() {
        load()
    }

    // MARK: - Persistence
    private func save() {
        let payload = Persisted(balance: balance, categories: categories, history: history)
        guard let data = try? JSONEncoder().encode(payload) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let payload = try? JSONDecoder().decode(Persisted.self, from: data) else {
            return
        }
        self.balance = payload.balance
        self.categories = payload.categories
        self.history = payload.history
    }

    private struct Persisted: Codable {
        var balance: Double
        var categories: [Category]
        var history: [Transaction]
    }
}
