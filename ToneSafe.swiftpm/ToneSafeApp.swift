import SwiftUI

@main
struct ToneSafeApp: App {
    @StateObject private var classifier = ClassifierService()
    @State private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
                    .environmentObject(classifier)
                    .preferredColorScheme(.light)
                    .transition(.opacity)
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                    .preferredColorScheme(.light)
                    .transition(.opacity)
            }
        }
    }
}
