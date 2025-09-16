//
//  ContentView.swift
//  CoinTrack
//
//  Created by Brady Cai on 9/15/25.
//
import SwiftUI

struct ContentView: View {
    @State private var tasks: [String] = []
    @State private var newTask: String = ""

    var body: some View {
        NavigationView {
            VStack {
                // Input field + button
                HStack {
                    TextField("Enter new task", text: $newTask)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button(action: {
                        if !newTask.isEmpty {
                            tasks.append(newTask)
                            newTask = "" // clear input
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                }

                // Task list
                List {
                    ForEach(tasks, id: \.self) { task in
                        Text(task)
                    }
                    .onDelete(perform: deleteTask)
                }
            }
            .navigationTitle("My To-Do List")
        }
    }

    // Function to delete tasks
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

// Preview for Xcode canvas
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
