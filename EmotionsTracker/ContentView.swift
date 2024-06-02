import SwiftUI

struct ContentView: View {
    
    @AppStorage("selectedColorTheme") private var selectedColorTheme: Int = 1
    @State private var createNewEmotionLog = false
    
    var body: some View {
        TabView {
            JournalView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Journal")
                }
            InsightsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Insights")
                }
            AffirmationsView()
                .tabItem {
                    Image(systemName: "star.bubble.fill")
                    Text("Affirmations")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .tint(ColorManager.colorFromIndex(index: selectedColorTheme))
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("dailyReminder"))) { _ in
            createNewEmotionLog.toggle()
        }
        .sheet(isPresented: $createNewEmotionLog) {
            AddView()
        }
    }
}


#Preview {
    ContentView()
}
