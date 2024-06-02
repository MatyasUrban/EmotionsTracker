import CoreLocation

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locationManager = CLLocationManager()
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var hasLocationPermission: Bool = false

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationAccess()
    }

    func requestLocationAccess() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkPermissions()
    }

    func checkPermissions() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            hasLocationPermission = true
            locationManager.startUpdatingLocation()
        default:
            hasLocationPermission = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        currentLocation = newLocation.coordinate
    }
}
