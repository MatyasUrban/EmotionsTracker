import Foundation
import SwiftData

@Model
class EmotionLog {
    var datetime: Date
    var mood: Double
    var feeling: String
    var emotion: String
    var context: String
    var latitude: Double?
    var longitude: Double?
    init(datetime: Date, mood: Double, feeling: String, emotion: String, context: String, latitude: Double? = nil, longitude: Double? = nil){
        self.datetime = datetime
        self.mood = mood
        self.feeling = feeling
        self.emotion = emotion
        self.context = context
        self.latitude = latitude
        self.longitude = longitude
    }
}
