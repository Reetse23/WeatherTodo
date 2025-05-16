import SwiftUI

struct WeatherView: View {
    @ObservedObject var weatherVM: WeatherViewModel
    
    func convertTo24HourFormat(time: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "hh:mm a"
        inputFormatter.locale = Locale(identifier: "en_US")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        
        if let date = inputFormatter.date(from: time) {
            return outputFormatter.string(from: date)
        }
        
        return time
    }
    
    var body: some View {
        Group {
            if weatherVM.isLoading {
                ProgressView()
                    .frame(height: 100)
            } else if let weather = weatherVM.weatherData {
                VStack(spacing: 15) {
                    // Location name centered
                    Text(weather.location.name)
                        .font(.title3)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .center)

                    HStack {
                        VStack {
                            ZStack {
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: "sunrise.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            }
                            Text(convertTo24HourFormat(time: weather.forecast.forecastday[0].astro.sunrise))
                                .font(.caption)
                        }

                        Spacer()

                        VStack {
                            ZStack {
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .frame(width: 60, height: 60)

                                Image(systemName: "thermometer")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 40)
                            }
                            Text("\(Int(weather.current.temp_c))°C")
                                .font(.caption)
                        }

                        Spacer()

                        VStack {
                            ZStack {
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .frame(width: 60, height: 60)

                                Image(systemName: "sunset.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            }
                            Text(convertTo24HourFormat(time: weather.forecast.forecastday[0].astro.sunset))
                                .font(.caption)
                        }
                    }
                    .padding(.bottom, 10)
                    .padding(.horizontal, 20)

                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(
                            colors: weather.current.temp_c > 17
                                ? [.cyan, .yellow, .orange]
                                : [.blue, .cyan, .yellow]
                        ),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(20)
                .foregroundColor(.black)
            } else if let error = weatherVM.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
                    .font(.caption)
                    .frame(height: 100)
            } else {
                VStack {
                    Text("Name: ")
                        .font(.headline)
                    Text("Current: °C")
                        .font(.subheadline)
                    Text("Sunrise: ")
                        .font(.subheadline)
                    Text("Sunset: ")
                        .font(.subheadline)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .orange]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(20)
                .redacted(reason: .placeholder)
            }
        }
    }
}


struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
