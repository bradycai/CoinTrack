import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @EnvironmentObject var data: AppData
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title: String = ""
    @State private var amountText: String = ""
    @State private var selectedType: TransactionType = .expense
    @State private var selectedCategoryId: UUID?
    @State private var selectedDate: Date = Date()
    @State private var note: String = ""

    private var parsedAmount: Double? {
        Double(amountText.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    private var isValidAmount: Bool {
        guard let parsedAmount else { return false }
        return parsedAmount > 0
    }

    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        isValidAmount &&
        selectedCategoryId != nil
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                VStack(alignment: .leading, spacing: 8) {
                    Text("New Transaction")
                        .font(.system(size: 30, weight: .bold))

                    Text("Log income or expenses quickly and keep your budget updated.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text("Transaction Details")
                        .font(.title3)
                        .fontWeight(.bold)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.subheadline.weight(.semibold))

                        TextField("Example: Groceries, Salary, Uber", text: $title)
                            .textFieldStyle(.plain)
                            .padding(14)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Amount")
                            .font(.subheadline.weight(.semibold))

                        TextField("0.00", text: $amountText)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.plain)
                            .padding(14)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type")
                            .font(.subheadline.weight(.semibold))

                        Picker("Type", selection: $selectedType) {
                            Text("Expense").tag(TransactionType.expense)
                            Text("Income").tag(TransactionType.income)
                        }
                        .pickerStyle(.segmented)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                            .font(.subheadline.weight(.semibold))

                        if data.categories.isEmpty {
                            Text("No categories available.")
                                .foregroundColor(.secondary)
                                .padding(14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        } else {
                            Picker("Category", selection: $selectedCategoryId) {
                                Text("Select a category").tag(UUID?.none)

                                ForEach(data.categories) { category in
                                    HStack {
                                        Image(systemName: category.icon)
                                        Text(category.name)
                                    }
                                    .tag(Optional(category.id))
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date")
                            .font(.subheadline.weight(.semibold))

                        DatePicker(
                            "Transaction Date",
                            selection: $selectedDate,
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .datePickerStyle(.graphical)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Note")
                            .font(.subheadline.weight(.semibold))

                        TextField("Optional note", text: $note, axis: .vertical)
                            .lineLimit(3...5)
                            .textFieldStyle(.plain)
                            .padding(14)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
                .padding(18)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                Button(action: saveTransaction) {
                    Text("Save Transaction")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isFormValid ? Color.green : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .disabled(!isFormValid)

                Spacer(minLength: 20)
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onAppear {
            if selectedCategoryId == nil {
                selectedCategoryId = data.categories.first?.id
            }
        }
    }

    private func saveTransaction() {
        guard
            let amount = parsedAmount,
            amount > 0,
            let categoryId = selectedCategoryId
        else {
            return
        }

        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)

        let newTransaction = Transaction(
            title: trimmedTitle,
            amount: amount,
            type: selectedType,
            categoryId: categoryId,
            date: selectedDate,
            note: trimmedNote
        )

        modelContext.insert(newTransaction)
        dismiss()
    }
}

#Preview {
    AddTransactionView()
        .environmentObject(AppData())
}
