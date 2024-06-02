import SwiftUI

struct AddView: View {
    @StateObject private var locationManager = LocationManager()
    @Environment(\.dismiss) private var dismiss;
    @Environment(\.modelContext) private var modelContext;
    @State private var date: Date = Date()
    @State private var time: Date = Date()
    @State private var locationSwitch: Bool = false
    @State private var mood: Double = 5
    @State private var selectedFeeling: String = "Select"
    @State private var selectedEmotion: String = "Select"
    @State private var context: String = ""
    @State private var latitude: Double? = nil;
    @State var longitude: Double? = nil;
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("BASIC INFO")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    Toggle("Location", isOn: $locationSwitch)
                        .onChange(of: locationSwitch) { oldValue, newValue in
                            if newValue && !locationManager.checkLocationAuthorization() {
                                locationSwitch.toggle()
                            }
                        }
                }
                
                Section(header: Text("MOOD RATING")) {
                    Slider(value: $mood, in: 0...10, step: 0.01) {
                        Text("Mood")
                    }
                    .toggleStyle(.automatic)
                }
                Section(header: Text("ENTRY DETAILS")) {
                    Picker("Feeling", selection: $selectedFeeling) {
                        ForEach(FeelingsEmotions.feelings, id: \.self) { feeling in
                            Text(feeling).tag(feeling as String?)
                        }
                    }
                    Picker("Emotion", selection: $selectedEmotion) {
                        Text("Select").tag("Select")
                        ForEach(FeelingsEmotions.emotions[selectedFeeling] ?? [], id: \.self) { emotion in
                            Text(emotion).tag(emotion as String?)
                        }
                    }
                    .disabled(selectedFeeling == "Select")
                    TextField("Context", text: $context)
                }
            }
            .navigationTitle("Emotion Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .cancellationAction) {
                    Button("Cancel"){
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button("Add"){
                        addEmotionLog()
                        dismiss();
                    }
                    .disabled(isAddButtonDisabled)
                }
            }
            
        }
        
    }
    
    private func addEmotionLog() {
        if locationSwitch && locationManager.lastKnownLocation != nil && locationManager.lastKnownLocation?.latitude != 0.0 {
            latitude = locationManager.lastKnownLocation?.latitude
            longitude = locationManager.lastKnownLocation?.longitude
        }
        let combinedDateTime = combineDateAndTime(date: date, time: time)
        let newLog = EmotionLog(
            datetime: combinedDateTime,
            mood: mood,
            feeling: selectedFeeling,
            emotion: selectedEmotion,
            context: context,
            latitude:  latitude,
            longitude: longitude
        )
        
        modelContext.insert(newLog)
        dismiss()
    }
    
    private func combineDateAndTime(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        
        return calendar.date(from: combinedComponents) ?? Date()
    }
    
    
    private var isAddButtonDisabled: Bool {
        selectedEmotion == "Select" || selectedFeeling == "Select" || FeelingsEmotions.emotionDoesntMatchFeeling(selectedFeeling: selectedFeeling, selectedEmotion: selectedEmotion)
    }
}

#Preview {
    AddView()
}
