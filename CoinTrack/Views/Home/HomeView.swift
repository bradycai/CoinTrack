import SwiftUI

struct HomeView: View {
    @State private var showMenu = false
    @State private var selected: SideMenuOption = .dashboard

    var body: some View {
        ZStack(alignment: .leading) {

            // Main content
            NavigationStack {
                screenForSelectedOption()
                    .navigationTitle(selected.rawValue)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
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
                // Dim background when menu open
                if showMenu {
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                                showMenu = false
                            }
                        }
                }
            }

            // Side menu
            SideMenuView(selected: $selected)
                .frame(width: 280)
                .offset(x: showMenu ? 0 : -280)
                .shadow(radius: showMenu ? 8 : 0)
        }
        .onChange(of: selected) { _, _ in
            // auto-close menu after selection
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                showMenu = false
            }
        }
    }

    @ViewBuilder
    private func screenForSelectedOption() -> some View {
        switch selected {
        case .dashboard:
            ContentView()          // your existing view
        case .history:
            HistoryViewPlaceholder()
        case .categories:
            CategoriesViewPlaceholder()
        case .settings:
            SettingsViewPlaceholder()
        }
    }
}

// Temporary placeholders so it compiles
struct HistoryViewPlaceholder: View { var body: some View { Text("History Screen") } }
struct CategoriesViewPlaceholder: View { var body: some View { Text("Categories Screen") } }
struct SettingsViewPlaceholder: View { var body: some View { Text("Settings Screen") } }
