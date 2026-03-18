import SwiftUI
import SwiftData

@main
struct CoinTrackApp: App {
    @StateObject private var data = AppData()

    var body: some Scene {
        WindowGroup {
            AppShellView()
                .environmentObject(data)
        }
        .modelContainer(for: Transaction.self)
    }
}
