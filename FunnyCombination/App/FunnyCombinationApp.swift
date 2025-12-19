import SwiftUI
import SwiftData

@main
struct FunnyCombinationApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            HighScore.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SplashView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
