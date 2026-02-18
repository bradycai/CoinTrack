import Foundation

struct Category: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var total: Double = 0.0
    var input: String = ""
}
