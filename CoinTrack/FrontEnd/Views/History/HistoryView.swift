import SwiftUI
import SwiftData

struct HistoryView: View {
    @EnvironmentObject var data: AppData
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]

    var body: some View {
        Group {
            if transactions.isEmpty {
                ContentUnavailableView(
                    "No Transactions Yet",
                    systemImage: "list.bullet.rectangle",
                    description: Text("Your income and expenses will appear here.")
                )
            } else {
                List {
                    ForEach(transactions) { transaction in
                        HistoryTransactionRow(transaction: transaction)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color(.systemGroupedBackground))
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !transactions.isEmpty {
                    Button("Clear") {
                        clearAllTransactions()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(transactions[index])
        }
    }

    private func clearAllTransactions() {
        for transaction in transactions {
            modelContext.delete(transaction)
        }
    }
}

struct HistoryTransactionRow: View {
    @EnvironmentObject var data: AppData
    let transaction: Transaction

    private var category: BudgetCategory? {
        data.category(for: transaction.categoryId)
    }

    private var categoryColor: Color {
        guard let category else { return .gray }
        return colorFromName(category.color)
    }

    private var signedAmount: String {
        let prefix = transaction.type == .income ? "+" : "-"
        return "\(prefix)\(transaction.amount.asCurrency)"
    }

    private var amountColor: Color {
        transaction.type == .income ? .green : .red
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(categoryColor.opacity(0.15))
                    .frame(width: 46, height: 46)

                Image(systemName: category?.icon ?? "questionmark.circle.fill")
                    .foregroundColor(categoryColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.headline)

                Text(category?.name ?? "Unknown Category")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                if !transaction.note.isEmpty {
                    Text(transaction.note)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(signedAmount)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(amountColor)

                Text(transaction.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    HistoryView()
        .environmentObject(AppData())
}
