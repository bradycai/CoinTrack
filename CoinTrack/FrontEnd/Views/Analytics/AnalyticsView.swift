import SwiftUI

struct AnalyticsView: View {
    @EnvironmentObject var data: AppData

    private var topCategories: [(BudgetCategory, Double)] {
        data.categories
            .map { category in
                (category, data.spentAmount(for: category))
            }
            .sorted { $0.1 > $1.1 }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                VStack(alignment: .leading, spacing: 10) {
                    Text("Analytics")
                        .font(.system(size: 30, weight: .bold))

                    Text("Review your spending and income this month.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                HStack(spacing: 12) {
                    AnalyticsStatCard(
                        title: "Income",
                        value: data.thisMonthIncome.asCurrency,
                        tint: .green,
                        icon: "arrow.down.circle.fill"
                    )

                    AnalyticsStatCard(
                        title: "Expenses",
                        value: data.thisMonthExpenses.asCurrency,
                        tint: .red,
                        icon: "arrow.up.circle.fill"
                    )
                }

                VStack(alignment: .leading, spacing: 14) {
                    Text("Top Spending Categories")
                        .font(.title3)
                        .fontWeight(.bold)

                    if topCategories.isEmpty {
                        Text("No spending data yet.")
                            .foregroundColor(.secondary)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(topCategories.prefix(5), id: \.0.id) { category, amount in
                                HStack {
                                    HStack(spacing: 10) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(colorFromName(category.color).opacity(0.15))
                                                .frame(width: 38, height: 38)

                                            Image(systemName: category.icon)
                                                .foregroundColor(colorFromName(category.color))
                                        }

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(category.name)
                                                .font(.headline)

                                            Text("Budget \(category.monthlyBudget.asCurrency)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }

                                    Spacer()

                                    Text(amount.asCurrency)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .padding(14)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }
                        }
                    }
                }
                .padding(18)
                .background(Color(.systemGray6).opacity(0.45))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

struct AnalyticsStatCard: View {
    let title: String
    let value: String
    let tint: Color
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()

                Image(systemName: icon)
                    .foregroundColor(tint)
            }

            Text(value)
                .font(.headline)
                .fontWeight(.bold)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    AnalyticsView()
        .environmentObject(AppData())
}
