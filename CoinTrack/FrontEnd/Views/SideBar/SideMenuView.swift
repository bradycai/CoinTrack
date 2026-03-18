import SwiftUI

struct SideMenuView: View {
    @Binding var selected: SideMenuOption

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {

            HStack(spacing: 12) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text("BC")
                            .font(.headline)
                            .foregroundColor(.white)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text("CoinTrack")
                        .font(.headline)

                    Text("Welcome back")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 12)

            Divider()

            ForEach(SideMenuOption.allCases) { option in
                Button {
                    selected = option
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: option.icon)
                            .frame(width: 22)
                            .foregroundColor(selected == option ? .green : .primary)

                        Text(option.rawValue)
                            .font(.subheadline)
                            .foregroundColor(.primary)

                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(
                        selected == option
                        ? Color.green.opacity(0.12)
                        : Color.clear
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .buttonStyle(.plain)
            }

            Spacer()
        }
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
    }
}

#Preview {
    @Previewable @State var selected: SideMenuOption = .home
    SideMenuView(selected: $selected)
}
