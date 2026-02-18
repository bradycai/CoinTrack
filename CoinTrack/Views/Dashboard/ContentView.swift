import SwiftUI

struct ContentView: View {
    // MARK: - State
    @State private var balance: Double = 0.0
    @State private var amount: String = ""
    @State private var categories: [Category] = [
        Category(name: "Food"),
        Category(name: "Leisure"),
        Category(name: "Savings"),
        Category(name: "Other")
    ]
    @State private var newCategoryName: String = ""
    @State private var history: [Transaction] = []

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    // MARK: - Main Balance
                    Text("Total Balance: \(balance.asCurrency)")
                        .font(.largeTitle).bold()
                        .padding(.top, 50)

                    // Balance input
                    TextField("Enter amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .submitLabel(.done)
                        .onSubmit { if isValidPositiveNumber(amount) { addFunds() } }

                    // Add / Remove main balance
                    HStack(spacing: 16) {
                        Button(action: addFunds) {
                            Label("Add", systemImage: "plus.circle.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(!isValidPositiveNumber(amount))

                        Button(action: removeFunds) {
                            Label("Remove", systemImage: "minus.circle.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(!isValidPositiveNumber(amount))
                    }
                    .padding(.horizontal)

                    Divider().padding(.vertical, 1)

                    // MARK: - Categories Section
                    VStack(spacing: 15) {
                        HStack {
                            Text("Category")
                                .font(.headline).bold()
                            Spacer()
                            Button("Clear") { clearAllBalances() }
                                .foregroundColor(.red)
                        }

                        // Add category controls
                        HStack(spacing: 10) {
                            TextField("New category name", text: $newCategoryName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button("Add") { addCategory() }
                                .buttonStyle(.borderedProminent)
                                .disabled(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }

                        Divider().padding(.vertical, 5)

                        // Dynamic categories
                        VStack(spacing: 12) {
                            ForEach(Array(categories.enumerated()), id: \.element.id) { i, cat in
                                CategoryRow(
                                    title: cat.name,
                                    total: cat.total,
                                    input: $categories[i].input,
                                    onAdd: { addToCategory(i) },
                                    onRemove: { removeFromCategory(i) },
                                    onDelete: { deleteCategory(i) }
                                )
                            }
                        }
                    }
                    .padding(.horizontal)

                    Divider().padding(.vertical, 10)

                    // MARK: - Category Chart (donut)
                    CategoryChart(categories: categories)
                        .padding(.horizontal)

                    Divider().padding(.vertical, 10)

                    // MARK: - History Section
                    HStack {
                        Text("History").font(.headline)
                        Spacer()
                        Button("Clear") { history.removeAll() }
                            .foregroundColor(.red)
                    }
                    .padding(.horizontal)

                    // Scrollable History
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 8) {
                            ForEach(history.reversed()) { tx in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(tx.description)  \(tx.amount.asCurrency)")
                                        .fontWeight(.semibold)
                                    Text(tx.date, style: .time)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(10)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 200)

                    Spacer(minLength: 8)
                }
                .padding(.top, 8)
            }
            .navigationBarTitleDisplayMode(.inline)
            .scrollDismissesKeyboard(.interactively)
        }
    }

    // MARK: - Helpers
    private func parseAmount(_ text: inout String) -> Double? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        defer { text = "" }
        return Double(trimmed).flatMap { $0 > 0 ? $0 : nil }
    }

    private func log(_ description: String, _ amount: Double) {
        history.append(Transaction(description: description, amount: amount, date: Date()))
    }

    // MARK: - Balance funcs
    private func addFunds() {
        guard let value = parseAmount(&amount) else { return }
        balance += value
        log("Added to Balance", value)
    }

    private func removeFunds() {
        guard let value = parseAmount(&amount), balance >= value else { return }
        balance -= value
        log("Removed from Balance", value)
    }

    private func clearAllBalances() {
        let totalCleared = balance + categories.reduce(0) { $0 + $1.total }
        log("Cleared All Balances", totalCleared)
        balance = 0.0
        for i in categories.indices { categories[i].total = 0.0 }
    }

    // MARK: - Category
    private func addCategory() {
        let name = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        categories.append(Category(name: name))
        newCategoryName = ""
    }

    private func deleteCategory(_ i: Int) {
        guard categories.indices.contains(i) else { return }
        let cat = categories[i]
        if cat.total > 0 {
            balance += cat.total
            log("Deleted category \(cat.name) → returned to Balance", cat.total)
        }
        categories.remove(at: i)
    }

    // MARK: - Move funds
    private func addToCategory(_ i: Int) {
        guard categories.indices.contains(i),
              let value = parseAmount(&categories[i].input),
              balance >= value else { return }
        balance -= value
        categories[i].total += value
        log("Moved to \(categories[i].name)", value)
    }

    private func removeFromCategory(_ i: Int) {
        guard categories.indices.contains(i),
              let value = parseAmount(&categories[i].input),
              categories[i].total >= value else { return }
        categories[i].total -= value
        balance += value
        log("Moved from \(categories[i].name)", value)
    }
}

// MARK: - Validation & Formatting
private func isValidPositiveNumber(_ s: String) -> Bool {
    if let v = Double(s.trimmingCharacters(in: .whitespacesAndNewlines)) { return v > 0 }
    return false
}

extension Double {
    var asCurrency: String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.maximumFractionDigits = 2
        return f.string(from: NSNumber(value: self)) ?? "$0.00"
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 16 Pro")
    }
}
