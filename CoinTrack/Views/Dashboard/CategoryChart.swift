import SwiftUI
import Charts

struct CategoryChart: View {
    var categories: [Category]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Spending by Category")
                .font(.headline)

            // Show a donut chart of totals
            Chart(categories.filter { $0.total > 0 }, id: \.id) { cat in
                SectorMark(
                    angle: .value("Total", cat.total),
                    innerRadius: .ratio(0.55),  // donut style
                    angularInset: 2
                )
                .foregroundStyle(by: .value("Category", cat.name))
                .annotation(position: .overlay) {
                    // small labels only if big enough
                    if cat.total / max(1, categories.map(\.total).reduce(0,+)) > 0.12 {
                        Text(cat.name)
                            .font(.caption2)
                            .bold()
                    }
                }
            }
            .frame(height: 260)
        }
    }
}
