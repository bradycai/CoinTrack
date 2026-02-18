import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var data: AppData

    var body: some View {
        VStack {
            if data.history.isEmpty {
                ContentUnavailableView("No History Yet", systemImage: "clock")
                    .padding(.top, 40)
            } else {
                List {
                    ForEach(data.history.sorted(by: { $0.date > $1.date })) { tx in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(tx.description)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(tx.amount.asCurrency)
                            }
                            Text(tx.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.insetGrouped)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Clear") { data.history.removeAll() }
                    .foregroundColor(.red)
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        let sorted = data.history.sorted(by: { $0.date > $1.date })
        for idx in offsets {
            let item = sorted[idx]
            if let realIndex = data.history.firstIndex(where: { $0.id == item.id }) {
                data.history.remove(at: realIndex)
            }
        }
    }
}
