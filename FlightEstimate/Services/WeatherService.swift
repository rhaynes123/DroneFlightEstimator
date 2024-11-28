//
//  WeatherService.swift
//  FlightEstimate
//
//  Created by richard Haynes on 11/23/24.
//

import Foundation
import CoreLocation

final class WeatherService : ObservableObject{
    
    private func buildURL(lat : CLLocationDegrees, long : CLLocationDegrees) -> URL {
        let key = ""
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(key)")!
    }
    
    func getWeather(lat : CLLocationDegrees, long : CLLocationDegrees) async  -> WeatherResponse? {
        let url = buildURL(lat: lat, long: long)
        
        do {
            let (jsonData, response) = try await URLSession.shared.data(from: url)
            // Ensure the response is an HTTPURLResponse
            guard let httpResponse = response as? HTTPURLResponse else {
                return nil
            }

            // Check the status code
            guard (200...299).contains(httpResponse.statusCode) else {
               print("\(httpResponse.statusCode)")
                return nil
            }
            let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: jsonData)
            return weatherResponse
        }
        catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            return nil
        }
        catch {
            return nil
        }
    }
    
}
