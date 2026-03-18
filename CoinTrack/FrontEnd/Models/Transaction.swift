import Foundation
import SwiftData

@Model
final class Transaction: Identifiable {

    var id: UUID
    var title: String
    var amount: Double
    var type: TransactionType
    var categoryId: UUID
    var date: Date
    var note: String

    init(
        id: UUID = UUID(),
        title: String,
        amount: Double,
        type: TransactionType,
        categoryId: UUID,
        date: Date = Date(),
        note: String = ""
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.type = type
        self.categoryId = categoryId
        self.date = date
        self.note = note
    }
}
