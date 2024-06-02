import SwiftUI
import SwiftData
import MapKit
import CoreLocation

struct InsightsView: View {
    
    @AppStorage("selectedColorTheme") private var selectedColorTheme: Int = 1
    @Query(filter: EmotionLog.predicateForCurrentPeriod(), sort: [SortDescriptor(\EmotionLog.datetime)])
    private var currentData: [EmotionLog]
    @Query(filter: EmotionLog.predicateForPreviousPeriod(), sort: [SortDescriptor(\EmotionLog.datetime)])
    private var previousData: [EmotionLog]
    @State private var currentMoodAverage: String = "Calculating..."
    @State private var previousMoodAverage: String = "Calculating..."
    @State private var currentMostFrequentFeeling: String = "Calculating..."
    @State private var previousMostFrequentFeeling: String = "Calculating..."
    
    let currentPeriodAverage: Double = 6.57
    let previousPeriodAverage: Double = 8.62
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    InsightCardView(
                        title: "Average Mood Rating",
                        currentValue: calculateMoodAverage(logs: currentData),
                        previousValue: calculateMoodAverage(logs: previousData),
                        selectedColorTheme: selectedColorTheme
                    )
                    
                    InsightCardView(
                        title: "Most Frequent Feeling",
                        currentValue: calculateMostFrequentFeeling(logs: currentData),
                        previousValue: calculateMostFrequentFeeling(logs: previousData),
                        selectedColorTheme: selectedColorTheme
                    )
                    Text("You've logged your emotions \(currentData.count) times during the past 7 days. Logs with saved locaton are being marked on the map.")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                    MapView(emotionLogs: currentData, selectedColorTheme: selectedColorTheme)
                }
                .padding()
            }
            .navigationTitle("Insights")
        }
        .onAppear {
            updateData()
        }
        .onChange(of: currentData) { updateData() }
        .onChange(of: previousData) { updateData() }
    }
    
    private func updateData() {
        currentMoodAverage = calculateMoodAverage(logs: currentData)
        previousMoodAverage = calculateMoodAverage(logs: previousData)
        currentMostFrequentFeeling = calculateMostFrequentFeeling(logs: currentData)
        previousMostFrequentFeeling = calculateMostFrequentFeeling(logs: previousData)
    }
    
    static func datePredicate(startDaysAgo start: Int, endDaysAgo end: Int) -> Predicate<EmotionLog> {
        let endDate = Date().addingTimeInterval(-Double(end * 24 * 60 * 60))
        let startDate = Date().addingTimeInterval(-Double(start * 24 * 60 * 60))
        return #Predicate<EmotionLog> {
            $0.datetime >= startDate && $0.datetime < endDate
        }
    }
    
    func calculateMoodAverage(logs: [EmotionLog]) -> String {
        guard !logs.isEmpty else { return "No data" }
        let totalMood = logs.reduce(0.0) { $0 + $1.mood }
        let averageMood = totalMood / Double(logs.count)
        return String(format: "%.2f", averageMood)
    }
    
    func calculateMostFrequentFeeling(logs: [EmotionLog]) -> String {
        guard !logs.isEmpty else { return "No data" }
        let feelingsCount = logs.reduce(into: [:]) { counts, log in
            counts[log.feeling, default: 0] += 1
        }
        if let mostFrequentFeeling = feelingsCount.max(by: { a, b in a.value < b.value || (a.value == b.value && a.key > b.key) })?.key {
            return mostFrequentFeeling
        }
        return "No data"
    }
}

struct InsightCardView: View {
    let title: String
    let currentValue: String
    let previousValue: String
    let selectedColorTheme: Int
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 10)
            HStack {
                VStack {
                    
                    Text(previousValue)
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Previous 7 days")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                Spacer()
                VStack {
                    Text(currentValue)
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Text("Current 7 days")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                }
            }
        }
        .padding()
        .background(ColorManager.colorFromIndex(index: selectedColorTheme))
        .cornerRadius(10)
        .foregroundColor(.white)

        
    }
}

struct MapView: View {
    let emotionLogs: [EmotionLog]
    let selectedColorTheme: Int

    var body: some View {
        Map(){
            ForEach(emotionLogs) { log in
                if log.latitude != nil {
                    Marker("", coordinate: CLLocationCoordinate2D(latitude: log.latitude!, longitude: log.longitude!))
                        
                        
                }
            }
        }
        .foregroundColor(ColorManager.colorFromIndex(index: selectedColorTheme))
        .frame(height: 200)
        .cornerRadius(10)
    }
}

extension EmotionLog {
    static func predicateForCurrentPeriod() -> Predicate<EmotionLog> {
        let currentDate = Date()
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: currentDate)!
        
        return #Predicate<EmotionLog> { log in
            log.datetime >= sevenDaysAgo && log.datetime < currentDate
        }
    }
    
    static func predicateForPreviousPeriod() -> Predicate<EmotionLog> {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let fourteenDaysAgo = Calendar.current.date(byAdding: .day, value: -14, to: Date())!
        
        return #Predicate<EmotionLog> { log in
            log.datetime >= fourteenDaysAgo && log.datetime < sevenDaysAgo
        }
    }
}

#Preview {
    InsightsView()
}
