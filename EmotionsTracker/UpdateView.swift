import SwiftUI

struct UpdateView: View {
    
    @Environment(\.dismiss) var dismiss;
    @State private var mood: Double = 5
    @State private var selectedFeeling: String = "Select"
    @State private var selectedEmotion: String = "Select"
    @State private var context: String = ""
    let emotionLog: EmotionLog
    
    public var body: some View {
        NavigationStack {
            Form {
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
                    Button("Update"){
                        updateEmotionLog()
                    }
                    .disabled(isUpdateButtonDisabled)
                }
            }
        }
        .onAppear{
            mood = emotionLog.mood
            selectedFeeling = emotionLog.feeling
            selectedEmotion = emotionLog.emotion
            context = emotionLog.context
        }
        
    }
    
    
    private var changed: Bool {
        mood != emotionLog.mood ||
        selectedFeeling != emotionLog.feeling ||
        selectedEmotion != emotionLog.emotion ||
        context != emotionLog.context
    }
    
    private func updateEmotionLog() {
        emotionLog.mood = mood
        emotionLog.feeling = selectedFeeling
        emotionLog.emotion = selectedEmotion
        emotionLog.context = context
        dismiss()
    }
    
    
    private var isUpdateButtonDisabled: Bool {
        selectedEmotion == "Select" || selectedFeeling == "Select" || FeelingsEmotions.emotionDoesntMatchFeeling(selectedFeeling: selectedFeeling, selectedEmotion: selectedEmotion) || !changed
    }
}
