# Emotions Tracker

This is my semester project in *Principles of Mobile Applications*  [B6B39PDA](https://bilakniha.cvut.cz/en/predmet3132306.html#gsc.tab=0) course as part of my Software Engineering undergraduate curriculum at the Czech Technical University in Prague, CZ, EU.

Designed, developed and programmed by  [Matyas Urban](https://www.linkedin.com/in/matyasurban/)  in Spring 2024.

## Overview
Emotions Tracker is a Swift-based iOS application designed to help users monitor and log their emotional states over time. The app leverages SwiftUI for its user interface, SwiftData for data persistence, and MapKit for geolocation features. This project was developed as part of a university course on mobile app development, adhering to the latest Apple Human Interface Guidelines and utilizing new capabilities introduced at WWDC 2023.

## Comprehensive Documentation
- [emotionsTrackerDemo.pdf](./emotionsTrackerDemo.pdf): LinkedIn slide deck demonstrating the Emotions Tracker app.
- [emotionsTrackerD1.pdf](./emotionsTrackerD1.pdf): Detailed description and key functionalities of the Emotions Tracker app.
- [emotionsTrackerD2.pdf](./emotionsTrackerD2.pdf): Technical documentation and user experience testing results for the Emotions Tracker app.

## Features
- **Emotion Logging**: Track and log emotional states with mood ratings, feelings, and specific emotions.
- **Location Tagging**: Utilize device GPS to tag emotional logs with geographical information.
- **Affirmations**: Fetch personalized motivational messages using device shake gestures.
- **Insights**: Analyze mood trends and emotional patterns over time.
- **Customization**: Personalize the app’s appearance with dynamic color themes and custom affirmations.
- **Notifications**: Set daily reminders to log emotions.

## Installation

### Requirements
- Xcode 15 or later
- iOS 17 simulator

### Steps
1. Download the source code from [GitHub](https://github.com/MatyasUrban/EmotionsTracker) or [GitLab](https://gitlab.fel.cvut.cz/urbanm48/emotionstracker).
2. Open Xcode and navigate to `Code > Download ZIP`.
3. Unzip the downloaded file and open the project in Xcode (`EmotionsTracker.xcodeproj`).
4. Trust and open the project.
5. Run the project on an emulated device with iOS 17.

## Technical Details

### Mobile Aspects

#### Hardware
- **Device Compatibility**: Designed for iPhones running iOS 17 or later.
- **Location Services**: Utilizes GPS for logging and displaying user location.
- **Shake Detection**: Uses the accelerometer to detect shake gestures for fetching new affirmations.

#### Software
- **Development Language**: Swift
- **Frameworks and Libraries**:
  - **SwiftUI**: For modern, declarative UI development.
  - **UIKit**: For interfacing with iOS components.
  - **CoreLocation**: For location data management.
  - **MapKit**: For geolocation and map display.
  - **UserNotifications**: For handling local notifications.
  - **SwiftData**: For data persistence.
  - **URLSession**: For network requests.

### Key Components

#### State Management
- Utilizes `@State`, `@StateObject`, `@AppStorage`, and `@Environment` properties for reactive UI updates.

#### UI Components and Navigation
- **NavigationStack**: Manages view transitions.
- **Forms and Pickers**: Collects user input for emotional logs.
- **Maps Integration**: Displays interactive maps using MapKit.
- **Custom View Modifiers**: Extends SwiftUI functionality, such as `DeviceShakeViewModifier` for shake gestures.

#### Data Persistence
- **SwiftData**: Manages emotional logs with efficient querying, inserting, and deleting.
- **Model Definitions**: Structures data models for emotional logs.

#### Network Requests
- **URLSession and Async/Await**: Implements asynchronous network requests for fetching affirmations.

#### Notifications
- **UserNotifications**: Manages local notifications for logging reminders.
- **Notification Scheduling**: Allows user-configured daily reminders.

#### Customization
- **AppStorage**: Persists user preferences such as personalized affirmations and custom themes.
- **Dynamic Theme Management**: Allows users to select custom themes compatible with dark mode.

## User Experience Testing

### Achievement Score Scale
- **A**: Task achieved easily.
- **B**: Task achieved slowly.
- **C**: Task achieved with a hint.
- **F**: Task not completed without instructions.

### Test Questions and Notes
1. **Log a New Emotion**: High user satisfaction.
2. **View Detailed Log Information**: Improved discoverability needed.
3. **Update an Existing Log**: Efficient after discovering update functionality.
4. **Personalize an Affirmation**: Easily achieved.
5. **Receive a New Affirmation**: User-friendly.
6. **Set a Daily Notification Reminder**: Simple configuration.
7. **Change the App's Theme Color**: Intuitive customization.
8. **Delete a Log Entry**: Improved discoverability needed for swipe-to-delete.

### Findings and Recommendations
- **Discoverability of Actions**: Improve visibility of key actions like "Open in Maps" and delete logs.
- **Feedback on Settings Changes**: Implement confirmation messages for setting changes.
- **Alternative Interaction Methods**: Add pull-to-refresh for new affirmations.

## Conclusion
Emotions Tracker is a robust tool for monitoring and understanding emotional health. It combines modern iOS technologies with user-centric design principles to offer a seamless and insightful experience. Check out the project on [GitHub](https://github.com/MatyasUrban/EmotionsTracker)
