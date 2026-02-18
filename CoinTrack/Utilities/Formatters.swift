import Foundation

extension Double {
    var asCurrency: String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.maximumFractionDigits = 2
        return f.string(from: NSNumber(value: self)) ?? "$0.00"
    }
}
