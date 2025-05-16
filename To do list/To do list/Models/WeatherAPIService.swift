import Foundation

class WeatherAPIService: WeatherServiceProtocol {
    private let apiKey = "9dea56d1e04c4f7591d165319252104"
    private let baseURL = "https://api.weatherapi.com/v1/forecast.json"
    
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let urlString = "\(baseURL)?key=\(apiKey)&q=\(latitude),\(longitude)&days=1&aqi=no&alerts=no"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.cannotParseResponse)))
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
