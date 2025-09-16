//
//  ContentView.swift
//  CoinTrack
//
//  Created by Brady Cai on 9/15/25.
//
import SwiftUI

struct ContentView: View {
    @State private var balance: Double = 0.0
    @State private var amount: String = ""   // user input

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Display current balance
                Text("Balance: $\(balance, specifier: "%.2f")")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                // Input field
                TextField("Enter amount", text: $amount)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Buttons
                HStack(spacing: 40) {
                    Button(action: addFunds) {
                        Label("Add", systemImage: "plus.circle.fill")
                            .font(.title2)
                            .padding()
                            .background(Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    Button(action: removeFunds) {
                        Label("Remove", systemImage: "minus.circle.fill")
                            .font(.title2)
                            .padding()
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
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
}

// Preview for Xcode canvas
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
