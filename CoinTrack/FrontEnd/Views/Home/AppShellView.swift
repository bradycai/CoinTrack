import SwiftUI

struct AppShellView: View {
    @State private var showMenu = false
    @State private var selected: SideMenuOption = .home

    var body: some View {
        ZStack(alignment: .leading) {

            NavigationStack {
                screenForSelectedOption()
                    .navigationTitle(selected.rawValue)
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                                    showMenu.toggle()
                                }
                            } label: {
                                Image(systemName: "line.3.horizontal")
                            }
                        }
                    }
            }
            .disabled(showMenu)
            .overlay {
                if showMenu {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                                showMenu = false
                            }
                        }
                }
            }

            SideMenuView(selected: $selected)
                .frame(width: 280)
                .offset(x: showMenu ? 0 : -280)
                .shadow(color: .black.opacity(showMenu ? 0.12 : 0), radius: 10, x: 4, y: 0)
        }
        .onChange(of: selected) { _, _ in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                showMenu = false
            }
        }
    }

    @ViewBuilder
    private func screenForSelectedOption() -> some View {
        switch selected {
        case .home:
            HomeView(selected: $selected)

        case .dashboard:
            ContentView()

        case .addTransaction:
            AddTransactionView()

        case .history:
            HistoryView()

        case .analytics:
            AnalyticsView()

        case .categories:
            PlaceholderScreen(
                title: "Budgets",
                subtitle: "This screen is the next one to rebuild."
            )

        case .settings:
            PlaceholderScreen(
                title: "Settings",
                subtitle: "Settings will go here later."
            )
        }
    }
}

struct PlaceholderScreen: View {
    let title: String
    let subtitle: String

    var body: some View {
        ContentUnavailableView(
            title,
            systemImage: "square.and.pencil",
            description: Text(subtitle)
        )
    }
}

#Preview {
    AppShellView()
        .environmentObject(AppData())
}
