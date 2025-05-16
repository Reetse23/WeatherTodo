import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherData, Error>) -> Void)
}
