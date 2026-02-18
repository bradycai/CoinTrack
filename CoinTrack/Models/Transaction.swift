import Foundation

struct Transaction: Identifiable {
    let id = UUID()
    let description: String
    let amount: Double
    let date: Date
}
