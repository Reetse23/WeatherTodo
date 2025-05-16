import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let weatherVM: WeatherViewModel
    
    init(weatherVM: WeatherViewModel) {
        self.weatherVM = weatherVM
        super.init()
        locationManager.delegate = self
        requestLocationPermission()
    }
    
    private func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            weatherVM.error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Location access denied"])
            weatherVM.isLoading = false
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        weatherVM.fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        weatherVM.error = error
        weatherVM.isLoading = false
    }
}
