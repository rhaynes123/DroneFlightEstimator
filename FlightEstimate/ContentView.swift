//
//  ContentView.swift
//  FlightEstimate
//
//  Created by richard Haynes on 11/23/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationService: LocationService = .init()
    @StateObject private var weatherService: WeatherService = .init()
    
    //MARK --
    @State private var batteryCapacity: String = "" // in wh
    @State private var droneWeight: String = ""  // in g
    @State private var windSpeed: Double = 0       // in m/s (optional)
    @State private var calculatedFlightTime: String = ""
    var body: some View {
        VStack {
            Image(systemName: "paperplane.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Current Wind: \(windSpeed)")
                .font(.caption)
                .foregroundStyle(.secondary)
            Form {
                Section(header: Text("Drone Specifications")) {
                    TextField("Battery Capacity (wh)", text: $batteryCapacity)
                        .keyboardType(.decimalPad)
                    
                    TextField("Weight (g)", text: $droneWeight)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Environmental Factors")) {
                    TextField("Wind Speed (m/s) (Optional)", value: $windSpeed, format: .number)
                        .keyboardType(.decimalPad)
                        .disabled(true)
                }
                
                Section(header: Text("Estimated Flight Time")) {
                    if calculatedFlightTime.isEmpty {
                        Text("Enter values to calculate flight time.")
                            .foregroundColor(.gray)
                    } else {
                        Text("Estimated Flight Time: \(calculatedFlightTime) minutes")
                            .font(.headline)
                    }
                }
            }
            Button("Calculate Flight Time") {
                
                guard let location = locationService.location else
                {
                    print("location does not exist")
                    return
                }
                
                let lat: CLLocationDegrees = location.coordinate.latitude
                let lon: CLLocationDegrees = location.coordinate.longitude
                
                print("lat: \(lat), lon: \(lon)")
                
                Task {
                    guard let weather = await weatherService.getWeather(lat: lat, long: lon) else
                    {
                        print("weather does not exist")
                        return
                    }
                    print("\(weather.wind.speed)")
                    windSpeed = weather.wind.speed
                    calculatedFlightTime = Calculate(windSpeed: weather.wind.speed, BatteryLevel: Double(self.batteryCapacity) ?? 0, Weight: Double(self.droneWeight) ?? 0)
                }
                
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
        
        .padding()
        .onAppear {
            locationService.checkAuthorization()
        }
    }
}

#Preview {
    ContentView()
}
