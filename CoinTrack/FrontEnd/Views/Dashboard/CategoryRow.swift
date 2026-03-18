import SwiftUI

struct CategoryRow: View {
    let title: String
    let total: Double
    @Binding var input: String
    let onAdd: () -> Void
    let onRemove: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)

                    Text("Available")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(total.asCurrency)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.green)

                    Button(role: .destructive, action: onDelete) {
                        Text("Delete")
                            .font(.caption.weight(.semibold))
                    }
                }
            }

            // Controls
            HStack(spacing: 10) {

                TextField("Enter amount", text: $input)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Button(action: onAdd) {
                    Image(systemName: "arrow.down")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 42, height: 42)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(!isValidPositiveNumber(input))

                Button(action: onRemove) {
                    Image(systemName: "arrow.up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 42, height: 42)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(!isValidPositiveNumber(input))
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}

private func isValidPositiveNumber(_ s: String) -> Bool {
    if let v = Double(s.trimmingCharacters(in: .whitespacesAndNewlines)) {
        return v > 0
    }
    return false
}

#Preview {
    CategoryRow(
        title: "Food",
        total: 240.00,
        input: .constant("25"),
        onAdd: {},
        onRemove: {},
        onDelete: {}
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
