import Foundation

struct WeatherData: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
    
    struct Location: Codable {
        let name: String
    }
    
    struct Current: Codable {
        let temp_c: Double
    }
    
    struct Forecast: Codable {
        let forecastday: [ForecastDay]
    }
    
    struct ForecastDay: Codable {
        let astro: Astro
    }
    
    struct Astro: Codable {
        let sunrise: String
        let sunset: String
    }
}
