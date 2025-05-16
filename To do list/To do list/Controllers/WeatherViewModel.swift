import Foundation

class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol = WeatherAPIService()) {
        self.weatherService = weatherService
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
        isLoading = true
        error = nil
        
        weatherService.fetchWeather(latitude: latitude, longitude: longitude) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    self.weatherData = data
                case .failure(let error):
                    self.error = error
                    print("Weather API error: \(error.localizedDescription)")
                }
            }
        }
    }
}

