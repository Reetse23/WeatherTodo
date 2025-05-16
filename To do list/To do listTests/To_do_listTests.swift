import Testing
import XCTest
import CoreLocation
@testable import To_do_list

struct To_do_listTests {
    class MockWeatherService: WeatherServiceProtocol {
        var shouldReturnError = false
        var mockWeatherData: WeatherData?
        
        func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
            if shouldReturnError {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])))
            } else if let weatherData = mockWeatherData {
                completion(.success(weatherData))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No mock data"])))
            }
        }
    }
    
    class MockLocationManager: CLLocationManager {
        var mockAuthorizationStatus: CLAuthorizationStatus = .notDetermined
        
        override var authorizationStatus: CLAuthorizationStatus {
            return mockAuthorizationStatus
        }
    }
    
    private func createMockWeatherData() -> WeatherData {
        WeatherData(
            location: WeatherData.Location(name: "Test City"),
            current: WeatherData.Current(temp_c: 20.0),
            forecast: WeatherData.Forecast(
                forecastday: [
                    WeatherData.ForecastDay(
                        astro: WeatherData.Astro(
                            sunrise: "06:00 AM",
                            sunset: "06:00 PM"
                        )
                    )
                ]
            )
        )
    }
    
    @Test func testWeatherViewModelFetchWeatherSuccess() async throws {
        // Arrange
        let mockService = MockWeatherService()
        let mockWeatherData = createMockWeatherData()
        mockService.mockWeatherData = mockWeatherData
        let viewModel = WeatherViewModel(weatherService: mockService)
        let expectation = XCTestExpectation(description: "Weather fetch completes")
        
        viewModel.fetchWeather(latitude: 0.0, longitude: 0.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        XCTWaiter().wait(for: [expectation], timeout: 3.0)
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error == nil)
        #expect(viewModel.weatherData != nil)
        #expect(viewModel.weatherData?.location.name == "Test City")
        #expect(viewModel.weatherData?.current.temp_c == 20.0)
    }
    
    @Test func testWeatherViewModelFetchWeatherFailure() async throws {
        let mockService = MockWeatherService()
        mockService.shouldReturnError = true
        let viewModel = WeatherViewModel(weatherService: mockService)
        let expectation = XCTestExpectation(description: "Weather fetch fails")
        
        viewModel.fetchWeather(latitude: 0.0, longitude: 0.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        XCTWaiter().wait(for: [expectation], timeout: 3.0)
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error != nil)
        #expect(viewModel.weatherData == nil)
    }
    
    @Test func testLocationManagerAuthorizationDenied() async throws {
        let mockService = MockWeatherService()
        let viewModel = WeatherViewModel(weatherService: mockService)
        let locationManager = LocationManager(weatherVM: viewModel)
        let mockCLLocationManager = MockLocationManager()
        mockCLLocationManager.mockAuthorizationStatus = .denied
        
        locationManager.locationManagerDidChangeAuthorization(mockCLLocationManager)
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error != nil)
        #expect(viewModel.weatherData == nil)
        #expect((viewModel.error as NSError?)?.userInfo[NSLocalizedDescriptionKey] as? String == "Location access denied")
    }
    
    @Test func testWeatherViewConvertTo24HourFormat() async throws {
        let viewModel = WeatherViewModel()
        let weatherView = WeatherView(weatherVM: viewModel)
        
        #expect(weatherView.convertTo24HourFormat(time: "06:00 AM") == "06:00")
        #expect(weatherView.convertTo24HourFormat(time: "06:00 PM") == "18:00")
        #expect(weatherView.convertTo24HourFormat(time: "12:00 AM") == "00:00")
        #expect(weatherView.convertTo24HourFormat(time: "12:00 PM") == "12:00")
    }
    
    @Test func testWeatherAPIServiceInvalidURL() async throws {
        let service = WeatherAPIService()
        var receivedError: Error?
        let expectation = XCTestExpectation(description: "Weather API invalid URL")
        
        service.fetchWeather(latitude: 0.0, longitude: 0.0) { result in
            switch result {
            case .failure(let error):
                receivedError = error
            case .success:
                receivedError = nil
            }
            expectation.fulfill()
        }
        
        XCTWaiter().wait(for: [expectation], timeout: 3.0)
        
        #expect(receivedError != nil)
        #expect((receivedError as NSError?)?.domain != nil)
    }
}
