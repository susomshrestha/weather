//
//  Weather.swift
//  weather
//
//  Created by Susom Shrestha on 2023-03-26.
//

import Foundation

class Weather {
    
    static func getURL(location: String) -> URL? {
        let baseUrl = "https://api.weatherapi.com/v1";
        let currentEndpoint = "/forecast.json";
        let key = "key=d35a5e6ef05f448b8ba191139231303";
        let location = "q=\(location)"
        
        guard let endpoint = "\(baseUrl)\(currentEndpoint)?\(key)&\(location)&days=1&aqi=no&alerts=no".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        };
        
        return URL(string: endpoint);
    }
    
    static func searchWeather(location: String, callback: ((WeatherResponse) -> Void)?) {
        // get weather endpoint with locaiton
        guard let url = getURL(location: location) else {
            return;
        }
        
        // setup url session
        let urlSession = URLSession(configuration: .default);
        
        // setup data task
        let dataTask = urlSession.dataTask(with: url) { data, response, error in
            guard error == nil else {
                return;
            }
            
            guard let data = data else {
                return;
            }
            print(data)
            
            if let weatherRes = self.parseJson(data: data) {
                DispatchQueue.main.async {
                    // populate weather data from response
                    if let callback = callback {
                        callback(weatherRes);
                    }
                }
            }
            
        }
        
        // call api
        dataTask.resume();
    }
    
    static func parseJson(data: Data) -> WeatherResponse? {
        let decoder = JSONDecoder();
        var weatherResponse: WeatherResponse?;
        
        do {
            weatherResponse =  try decoder.decode(WeatherResponse.self, from: data)
        } catch {
            print(error)
        }
        
        return weatherResponse;
    }
}
