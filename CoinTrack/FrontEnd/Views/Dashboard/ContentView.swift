import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var data: AppData
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]

    @State private var showingAddTransaction = false

    private var balance: Double {
        totalIncome - totalExpenses
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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Total Balance")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.85))

                        Text(balance.asCurrency)
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

                    VStack(alignment: .leading, spacing: 16) {
                        Text("This Month")
                            .font(.title3)
                            .fontWeight(.bold)

                        HStack(spacing: 12) {
                            SummaryCard(
                                title: "Income",
                                value: thisMonthIncome.asCurrency,
                                icon: "arrow.down.circle.fill",
                                tint: .green
                            )

                            SummaryCard(
                                title: "Expenses",
                                value: thisMonthExpenses.asCurrency,
                                icon: "arrow.up.circle.fill",
                                tint: .red
                            )
                        }
                    }
                    .padding(18)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

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
                                    BudgetCategoryCard(category: category, transactions: transactions)
                                }
                            }
                        }
                    }
                    .padding(18)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Transactions")
                            .font(.title3)
                            .fontWeight(.bold)

                        if transactions.isEmpty {
                            Text("No transactions yet.")
                                .foregroundColor(.secondary)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(transactions.prefix(5)) { transaction in
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
            .navigationTitle("CoinTrack")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTransaction = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView()
            }
        }
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
    let category: BudgetCategory
    let transactions: [Transaction]

    private var spent: Double {
        transactions
            .filter { $0.categoryId == category.id && $0.type == .expense }
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
