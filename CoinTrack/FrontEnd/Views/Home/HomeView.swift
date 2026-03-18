import SwiftUI
import SwiftData

struct HomeView: View {
    @Binding var selected: SideMenuOption
    @EnvironmentObject var data: AppData
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]

    private var recentTransactions: [Transaction] {
        Array(transactions.prefix(3))
    }

    private var totalIncome: Double {
        transactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }

    private var totalExpenses: Double {
        transactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }

    private var balance: Double {
        totalIncome - totalExpenses
    }

    private var thisMonthTransactions: [Transaction] {
        let calendar = Calendar.current
        let now = Date()

        return transactions.filter { transaction in
            calendar.isDate(transaction.date, equalTo: now, toGranularity: .month) &&
            calendar.isDate(transaction.date, equalTo: now, toGranularity: .year)
        }
    }

    private var thisMonthIncome: Double {
        thisMonthTransactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }

    private var thisMonthExpenses: Double {
        thisMonthTransactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }

    private var budgetUsageText: String {
        if thisMonthExpenses == 0 {
            return "No spending recorded this month yet."
        } else {
            return "You've spent \(thisMonthExpenses.asCurrency) so far this month."
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                VStack(alignment: .leading, spacing: 8) {
                    Text("Overview")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.green.opacity(0.12))
                        .clipShape(Capsule())

                    Text("Welcome to CoinTrack")
                        .font(.system(size: 30, weight: .bold))

                    Text("Track your balance, manage your budget, and review your transactions all in one place.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Current Balance")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.85))

                    Text(balance.asCurrency)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)

                    Text(budgetUsageText)
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

                HStack(spacing: 12) {
                    HomeStatCard(
                        title: "Income",
                        value: thisMonthIncome.asCurrency,
                        icon: "arrow.down.circle.fill",
                        tint: .green
                    )

                    HomeStatCard(
                        title: "Expenses",
                        value: thisMonthExpenses.asCurrency,
                        icon: "arrow.up.circle.fill",
                        tint: .red
                    )
                }

                VStack(alignment: .leading, spacing: 14) {
                    Text("Quick Actions")
                        .font(.title3)
                        .fontWeight(.bold)

                    VStack(spacing: 14) {
                        Button {
                            selected = .addTransaction
                        } label: {
                            HomeActionCard(
                                title: "Add Transaction",
                                subtitle: "Log income or expenses quickly",
                                icon: "plus.circle.fill",
                                tint: .green
                            )
                        }
                        .buttonStyle(.plain)

                        Button {
                            selected = .history
                        } label: {
                            HomeActionCard(
                                title: "Transactions",
                                subtitle: "Review all of your income and expense history",
                                icon: "clock.fill",
                                tint: .teal
                            )
                        }
                        .buttonStyle(.plain)

                        Button {
                            selected = .analytics
                        } label: {
                            HomeActionCard(
                                title: "Analytics",
                                subtitle: "See how your spending compares this month",
                                icon: "chart.pie.fill",
                                tint: .indigo
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                VStack(alignment: .leading, spacing: 14) {
                    Text("Budget Preview")
                        .font(.title3)
                        .fontWeight(.bold)

                    if data.categories.isEmpty {
                        Text("No budget categories yet.")
                            .foregroundColor(.secondary)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(data.categories.prefix(3)) { category in
                                HomeBudgetPreviewRow(category: category, transactions: transactions)
                            }
                        }
                    }
                }
                .padding(18)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("Recent Transactions")
                            .font(.title3)
                            .fontWeight(.bold)

                        Spacer()

                        Button("See All") {
                            selected = .history
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.green)
                    }

                    if recentTransactions.isEmpty {
                        Text("No transactions yet.")
                            .foregroundColor(.secondary)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(recentTransactions) { transaction in
                                HomeTransactionPreviewRow(transaction: transaction)
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

struct HomeStatCard: View {
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
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct HomeActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let tint: Color

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(tint.opacity(0.14))
                    .frame(width: 48, height: 48)

                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(tint)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.footnote.weight(.semibold))
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct HomeBudgetPreviewRow: View {
    let category: BudgetCategory
    let transactions: [Transaction]

    private var spent: Double {
        let calendar = Calendar.current
        let now = Date()

        return transactions
            .filter {
                $0.categoryId == category.id &&
                $0.type == .expense &&
                calendar.isDate($0.date, equalTo: now, toGranularity: .month) &&
                calendar.isDate($0.date, equalTo: now, toGranularity: .year)
            }
            .reduce(0) { $0 + $1.amount }
    }

    private var remaining: Double {
        category.monthlyBudget - spent
    }

    private var progress: Double {
        guard category.monthlyBudget > 0 else { return 0 }
        return min(spent / category.monthlyBudget, 1.0)
    }

    private var tint: Color {
        colorFromName(category.color)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(tint.opacity(0.15))
                            .frame(width: 38, height: 38)

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
                        .font(.subheadline)
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

struct HomeTransactionPreviewRow: View {
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
    @Previewable @State var selected: SideMenuOption = .home

    HomeView(selected: $selected)
        .environmentObject(AppData())
}
