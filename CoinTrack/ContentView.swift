//
//  ContentView.swift
//  CoinTrack
//
//  Created by Brady Cai on 9/15/25.
//

import SwiftUI

// MARK: - Transaction model
struct Transaction: Identifiable {
    let id = UUID()
    let description: String
    let amount: Double
    let date: Date
}

struct ContentView: View {
    @State private var balance: Double = 0.0
    @State private var food: Double = 0.0
    @State private var leisure: Double = 0.0
    @State private var savings: Double = 0.0

    @State private var amount: String = ""

    @State private var foodInput: String = ""
    @State private var leisureInput: String = ""
    @State private var savingsInput: String = ""

    // MARK: - History log
    @State private var history: [Transaction] = []

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // MAIN BALANCE
                Text("Total Balance: $\(balance, specifier: "%.2f")")
                    .font(.largeTitle).bold()
                    .padding(.top)

                // Balance input
                TextField("Enter amount", text: $amount)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Add / Remove main balance
                HStack(spacing: 16) {
                    Button(action: addFunds) {
                        Label("Add", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: removeFunds) {
                        Label("Remove", systemImage: "minus.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)

                Divider().padding(.vertical, 10)

                // Subcategories
                VStack(spacing: 15) {
                    categoryRow(
                        title: "Food",
                        total: food,
                        input: $foodInput,
                        onAdd: { moveFunds(from: &balance, to: &food, using: &foodInput, desc: "to Food") },
                        onRemove: { moveFunds(from: &food, to: &balance, using: &foodInput, desc: "from Food") }
                    )
                    categoryRow(
                        title: "Leisure",
                        total: leisure,
                        input: $leisureInput,
                        onAdd: { moveFunds(from: &balance, to: &leisure, using: &leisureInput, desc: "to Leisure") },
                        onRemove: { moveFunds(from: &leisure, to: &balance, using: &leisureInput, desc: "from Leisure") }
                    )
                    categoryRow(
                        title: "Savings",
                        total: savings,
                        input: $savingsInput,
                        onAdd: { moveFunds(from: &balance, to: &savings, using: &savingsInput, desc: "to Savings") },
                        onRemove: { moveFunds(from: &savings, to: &balance, using: &savingsInput, desc: "from Savings") }
                    )
                }
                .padding(.horizontal)

                Divider().padding(.vertical, 10)

                // MARK: - History Log
                Text("History")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                List(history.reversed()) { tx in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(tx.description) $\(tx.amount, specifier: "%.2f")")
                            .font(.body)
                        Text(tx.date, style: .time)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(height: 200) // scrollable log

                Spacer()
            }
            .navigationTitle("CoinTrack")
        }
    }

    // MARK: - Balance funcs
    func addFunds() {
        if let value = Double(amount.trimmingCharacters(in: .whitespacesAndNewlines)), value > 0 {
            balance += value
            history.append(Transaction(description: "Added to Balance", amount: value, date: Date()))
            amount = ""
        }
    }

    func removeFunds() {
        if let value = Double(amount.trimmingCharacters(in: .whitespacesAndNewlines)), value > 0 {
            if balance >= value {
                balance -= value
                history.append(Transaction(description: "Removed from Balance", amount: value, date: Date()))
            }
            // else: not enough funds, maybe ignore or log an error
            amount = ""
        }
    }

    // MARK: - Move funds
    private func moveFunds(from source: inout Double, to target: inout Double, using input: inout String, desc: String) {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let value = Double(trimmed), value > 0 else { return }
        guard source >= value else { return }
        source -= value
        target += value
        history.append(Transaction(description: "Moved \(desc)", amount: value, date: Date()))
        input = ""
    }

    // MARK: - UI Helper (aligned columns)
    private let labelWidth: CGFloat  = 80
    private let totalWidth: CGFloat  = 80
    private let inputWidth: CGFloat  = 90
    private let buttonSize: CGFloat  = 36

    func categoryRow(
        title: String,
        total: Double,
        input: Binding<String>,
        onAdd: @escaping () -> Void,
        onRemove: @escaping () -> Void
    ) -> some View {
        HStack(spacing: 12) {
            Text("\(title):")
                .frame(width: labelWidth, alignment: .leading)

            Text("$\(total, specifier: "%.2f")")
                .font(.headline)
                .frame(width: totalWidth, alignment: .trailing)

            TextField("Amount", text: input)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: inputWidth, height: buttonSize)

            Button {
                onAdd()
            } label: {
                Image(systemName: "plus")
                    .font(.headline)
                    .frame(width: buttonSize, height: buttonSize)
                    .background(Color.green.opacity(0.85))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            Button {
                onRemove()
            } label: {
                Image(systemName: "minus")
                    .font(.headline)
                    .frame(width: buttonSize, height: buttonSize)
                    .background(Color.red.opacity(0.85))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
