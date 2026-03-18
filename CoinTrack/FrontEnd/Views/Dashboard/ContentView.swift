import SwiftUI

struct ContentView: View {
    @EnvironmentObject var data: AppData

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // MARK: - Header Card
                VStack(alignment: .leading, spacing: 10) {
                    Text("Total Balance")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.85))

                    Text(data.balance.asCurrency)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)

                    Text("Track your income, expenses, and monthly budget progress.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.82))
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        colors: [Color.green, Color.teal],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

                // MARK: - This Month Summary
                VStack(alignment: .leading, spacing: 16) {
                    Text("This Month")
                        .font(.title3)
                        .fontWeight(.bold)

                    HStack(spacing: 12) {
                        SummaryCard(
                            title: "Income",
                            value: data.thisMonthIncome.asCurrency,
                            icon: "arrow.down.circle.fill",
                            tint: .green
                        )

                        SummaryCard(
                            title: "Expenses",
                            value: data.thisMonthExpenses.asCurrency,
                            icon: "arrow.up.circle.fill",
                            tint: .red
                        )
                    }
                }
                .padding(18)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                // MARK: - Budget Categories
                VStack(alignment: .leading, spacing: 16) {
                    Text("Budget Categories")
                        .font(.title3)
                        .fontWeight(.bold)

                    if data.categories.isEmpty {
                        Text("No categories yet.")
                            .foregroundColor(.secondary)
                    } else {
                        VStack(spacing: 14) {
                            ForEach(data.categories) { category in
                                BudgetCategoryCard(category: category)
                            }
                        }
                    }
                }
                .padding(18)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                // MARK: - Recent Transactions
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recent Transactions")
                        .font(.title3)
                        .fontWeight(.bold)

                    if data.transactions.isEmpty {
                        Text("No transactions yet.")
                            .foregroundColor(.secondary)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(data.transactions.prefix(5)) { transaction in
                                TransactionRow(transaction: transaction)
                            }
                        }
                    }
                }
                .padding(18)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let tint: Color

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
                .foregroundColor(.primary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct BudgetCategoryCard: View {
    @EnvironmentObject var data: AppData
    let category: BudgetCategory

    private var spent: Double {
        data.spentAmount(for: category)
    }

    private var remaining: Double {
        data.remainingBudget(for: category)
    }

    private var progress: Double {
        data.budgetProgress(for: category)
    }

    private var tint: Color {
        colorFromName(category.color)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(tint.opacity(0.15))
                            .frame(width: 40, height: 40)

                        Image(systemName: category.icon)
                            .foregroundColor(tint)
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

                VStack(alignment: .trailing, spacing: 2) {
                    Text(spent.asCurrency)
                        .font(.headline)
                        .fontWeight(.semibold)

                    Text(remaining >= 0 ? "\(remaining.asCurrency) left" : "Over budget")
                        .font(.caption)
                        .foregroundColor(remaining >= 0 ? .secondary : .red)
                }
            }

            ProgressView(value: progress)
                .tint(tint)
        }
        .padding(14)
        .background(Color(.systemGray6).opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct TransactionRow: View {
    @EnvironmentObject var data: AppData
    let transaction: Transaction

    private var category: BudgetCategory? {
        data.category(for: transaction.categoryId)
    }

    private var tint: Color {
        guard let category else { return .gray }
        return colorFromName(category.color)
    }

    private var amountColor: Color {
        transaction.type == .income ? .green : .red
    }

    private var signedAmount: String {
        let prefix = transaction.type == .income ? "+" : "-"
        return "\(prefix)\(transaction.amount.asCurrency)"
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(tint.opacity(0.15))
                    .frame(width: 42, height: 42)

                Image(systemName: category?.icon ?? "questionmark.circle.fill")
                    .foregroundColor(tint)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(transaction.title)
                    .font(.headline)

                Text(category?.name ?? "Unknown Category")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text(signedAmount)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(amountColor)

                Text(transaction.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(Color(.systemGray6).opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    ContentView()
        .environmentObject(AppData())
}
