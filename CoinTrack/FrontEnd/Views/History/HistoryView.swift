import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var data: AppData

    private var sortedTransactions: [Transaction] {
        data.transactions.sorted { $0.date > $1.date }
    }

    var body: some View {
        Group {
            if sortedTransactions.isEmpty {
                ContentUnavailableView(
                    "No Transactions Yet",
                    systemImage: "list.bullet.rectangle",
                    description: Text("Your income and expenses will appear here.")
                )
            } else {
                List {
                    ForEach(sortedTransactions) { transaction in
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
                if !sortedTransactions.isEmpty {
                    Button("Clear") {
                        data.transactions.removeAll()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        let idsToDelete = offsets.map { sortedTransactions[$0].id }
        data.transactions.removeAll { idsToDelete.contains($0.id) }
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
