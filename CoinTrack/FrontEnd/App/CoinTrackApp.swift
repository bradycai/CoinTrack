import SwiftUI

@main
struct CoinTrackApp: App {
    @StateObject private var data = AppData()

    var body: some Scene {
        WindowGroup {
            AppShellView()
                .environmentObject(data)
        }
    }
}
