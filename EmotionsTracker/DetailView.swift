import SwiftUI
import MapKit

struct DetailView: View {
    @State private var updateExistingBook = false
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 50.096643, longitude: 14.455025),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    var emotionLog: EmotionLog
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Emotion Log Details")) {
                    TitleContentView(title: "Date", content: DateFormatter.localizedString(from: emotionLog.datetime, dateStyle: .medium, timeStyle: .none))
                    TitleContentView(title: "Time", content: DateFormatter.localizedString(from: emotionLog.datetime, dateStyle: .none, timeStyle: .short))
                    TitleContentView(title: "Mood Rating", content: String(format: "%.2f", emotionLog.mood))
                    TitleContentView(title: "Feeling", content: emotionLog.feeling)
                    TitleContentView(title: "Emotion", content: emotionLog.emotion)
                    if emotionLog.context != "" {
                        TitleContentView(title: "Context", content: emotionLog.context)
                    }
                }
                if emotionLog.latitude != nil && emotionLog.longitude != nil {
                    Section(header: Text("Location")) {
                        let coordinates = CLLocationCoordinate2D(latitude: emotionLog.latitude!, longitude: emotionLog.longitude!)
                        let position = MapCameraPosition.region(
                            MKCoordinateRegion(
                                center: coordinates,
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            )
                        )
                        Button("Open in Maps"){
                            openInMaps()
                        }
                        Map(initialPosition: position)
                        {
                            Marker("Emotion Log Location", coordinate: coordinates)
                        }
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .frame(height: 200)
                    }
                    
                    
                }
                
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button("Update Entry"){
                        updateExistingBook.toggle()
                    }
                    .sheet(isPresented: $updateExistingBook) {
                        UpdateView(emotionLog: emotionLog)
                            .presentationDetents([.medium])
                    }
                }
            }
        }
        
    }
    
    func openInMaps(){
        let latitude: CLLocationDegrees = emotionLog.latitude!
        let longitude: CLLocationDegrees = emotionLog.longitude!
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Emotion Log Location"
        mapItem.openInMaps(launchOptions: options)
    }
    
}

struct TitleContentView: View {
    var title: String
    var content: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 15, weight: .light))
                .foregroundColor(.gray)
            Text(content)
        }
    }
}
