import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    var manager = CLLocationManager()
    
    
    func checkLocationAuthorization() -> Bool {
        var approved = false
        manager.delegate = self
        manager.startUpdatingLocation()
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location restricted")
        case .denied:
            print("Location denied")
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            print("Location authorizedAlways")
            lastKnownLocation = manager.location?.coordinate
            approved = true
        case .authorizedWhenInUse:
            print("Location authorized when in use")
            lastKnownLocation = manager.location?.coordinate
            approved = true
        @unknown default:
            print("Location service disabled")
            
        }
        return approved
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        var _ = checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}
