import SwiftUI

struct CategoryRow: View {
    let title: String
    let total: Double
    @Binding var input: String
    let onAdd: () -> Void
    let onRemove: () -> Void
    let onDelete: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)

                Spacer()

                Text("$\(total, specifier: "%.2f")")
                    .font(.subheadline)
                    .lineLimit(1)
            }

            // Line 2: Input + buttons
            HStack(spacing: 12) {
                TextField("Amount", text: $input)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minWidth: 90, maxWidth: 160)
                    .layoutPriority(1)

                Button(action: onAdd) {
                    Image(systemName: "plus")
                        .frame(width: 36, height: 36)
                        .background(Color.gray.opacity(0.85))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Button(action: onRemove) {
                    Image(systemName: "minus")
                        .frame(width: 36, height: 36)
                        .background(Color.gray.opacity(0.85))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                if let onDelete = onDelete {
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .frame(width: 36, height: 36)
                            .background(Color.red.opacity(0.9))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
        .padding(.vertical, 6)
    }
}
