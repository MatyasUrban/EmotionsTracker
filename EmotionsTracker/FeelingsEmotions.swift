import Foundation

struct FeelingsEmotions {
    static let feelings = ["Select", "Anger", "Fear", "Sadness", "Disgust", "Enjoyment"]
    static let emotions: [String: [String]] = [
        "Select":[],
        "Anger": ["Annoyed", "Frustrated", "Peeved", "Contrary", "Bitter", "Infuriated", "Irritated", "Mad", "Cheated", "Vengeful", "Insulted"],
        "Fear": ["Worried", "Doubtful", "Nervous", "Anxious", "Terrified", "Panicked", "Horrified", "Desperate", "Confused", "Stressed"],
        "Sadness": ["Lonely", "Heartbroken", "Gloomy", "Disappointed", "Hopeless", "Grieved", "Unhappy", "Lost", "Troubled", "Resigned", "Miserable"],
        "Disgust": ["Dislike", "Revulsion", "Loathing", "Disapproving", "Offended", "Horrified", "Uncomfortable", "Nauseated", "Disturbed", "Withdrawn", "Aversion"],
        "Enjoyment": ["Happiness", "Love", "Relief", "Contentment", "Amusement", "Joy", "Pride", "Excitement", "Peace", "Satisfaction"],
    ]
    static func emotionDoesntMatchFeeling(selectedFeeling: String, selectedEmotion: String) -> Bool {
        guard let validEmotions = emotions[selectedFeeling] else {
            return true
        }
        return !validEmotions.contains(selectedEmotion)
    }
}
