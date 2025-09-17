import SwiftUI

struct ContentView: View {
    @State private var balance: Double = 0.0
    @State private var food: Double = 0.0
    @State private var leisure: Double = 0.0
    @State private var savings: Double = 0.0

    // Editable category names
    @State private var cat1Name = "Food"
    @State private var cat2Name = "Leisure"
    @State private var cat3Name = "Savings"

    @State private var amount: String = ""   // user input

    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                // MAIN BALANCE
                Text("Total Balance: $\(balance, specifier: "%.2f")")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                // Input field
                TextField("Enter amount", text: $amount)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Add / Remove buttons (equal widths)
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

                // Subcategories (editable names)
                VStack(spacing: 15) {
                    categoryRow(name: $cat1Name, amount: food, action: addToFood)
                    categoryRow(name: $cat2Name, amount: leisure, action: addToLeisure)
                    categoryRow(name: $cat3Name, amount: savings, action: addToSavings)
                }

                Spacer()
            }
            .navigationTitle("CoinTrack")
        }
    }

    // MARK: - Functions
    func addFunds() {
        if let value = Double(amount.trimmingCharacters(in: .whitespacesAndNewlines)), value > 0 {
            balance += value
            amount = ""
        }
    }

    func removeFunds() {
        if let value = Double(amount.trimmingCharacters(in: .whitespacesAndNewlines)), value > 0 {
            balance = max(0, balance - value)
            amount = ""
        }
    }

    func addToFood()    { moveFunds(to: &food) }
    func addToLeisure() { moveFunds(to: &leisure) }
    func addToSavings() { moveFunds(to: &savings) }

    private func moveFunds(to category: inout Double) {
        if let value = Double(amount.trimmingCharacters(in: .whitespacesAndNewlines)),
           value > 0, balance >= value {
            balance -= value
            category += value
            amount = ""
        }
    }

    // MARK: - UI Helper
    func categoryRow(name: Binding<String>, amount: Double, action: @escaping () -> Void) -> some View {
        HStack(spacing: 12) {
            TextField("Category", text: name)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Spacer()

            Text("$\(amount, specifier: "%.2f")")
                .font(.headline)
                .frame(minWidth: 90, alignment: .trailing)

            Button("Move") {
                action()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding(.horizontal)
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
