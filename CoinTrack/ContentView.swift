//
//  ContentView.swift
//  CoinTrack
//
//  Created by Brady Cai on 9/15/25.
//
import SwiftUI

struct ContentView: View {
    @State private var balance: Double = 0.0
    @State private var food: Double = 0.0
    @State private var leisure: Double = 0.0
    @State private var savings: Double = 0.0
    
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

                // Add / Remove buttons
                HStack(spacing: 40) {
                    Button(action: addFunds) {
                        Label("Add", systemImage: "plus.circle.fill")
                            .padding()
                            .background(Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: removeFunds) {
                        Label("Remove", systemImage: "minus.circle.fill")
                            .padding()
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                Divider().padding(.vertical, 10)

                // Subcategories
                VStack(spacing: 15) {
                    categoryRow(title: "Food", amount: food, action: addToFood)
                    categoryRow(title: "Leisure", amount: leisure, action: addToLeisure)
                    categoryRow(title: "Savings", amount: savings, action: addToSavings)
                }
                
                Spacer()
            }
            .navigationTitle("CoinTrack")
        }
    }

    // MARK: - Functions
    func addFunds() {
        if let value = Double(amount) {
            balance += value
            amount = ""
        }
    }

    func removeFunds() {
        if let value = Double(amount) {
            balance -= value
            amount = ""
        }
    }
    
    func addToFood() {
        moveFunds(to: &food)
    }
    
    func addToLeisure() {
        moveFunds(to: &leisure)
    }
    
    func addToSavings() {
        moveFunds(to: &savings)
    }
    
    private func moveFunds(to category: inout Double) {
        if let value = Double(amount), balance >= value {
            balance -= value
            category += value
            amount = ""
        }
    }
    
    // MARK: - UI Helper
    func categoryRow(title: String, amount: Double, action: @escaping () -> Void) -> some View {
        HStack {
            Text("\(title): $\(amount, specifier: "%.2f")")
                .font(.title3)
            Spacer()
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
