//
//  Weather.swift
//  weather
//
//  Created by Susom Shrestha on 2023-03-26.
//

import Foundation
import UIKit

class Weather {
    
    static func getURL(location: String, day: Int) -> URL? {
        let baseUrl = "https://api.weatherapi.com/v1";
        let currentEndpoint = "/forecast.json";
        let key = "key=d35a5e6ef05f448b8ba191139231303";
        let location = "q=\(location)"
        let day = "days=\(day)"
        
        guard let endpoint = "\(baseUrl)\(currentEndpoint)?\(key)&\(location)&\(day)&aqi=no&alerts=no".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        };
        
        return URL(string: endpoint);
    }
    
    static func searchWeather(location: String, day: Int = 1, callback: ((WeatherResponse) -> Void)?) {
        // get weather endpoint with locaiton
        guard let url = getURL(location: location, day: day) else {
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
    
    static func getIconCongiguration(_ code: Int, _ isDay: Int) -> UIImage.SymbolConfiguration {
        var config: UIImage.SymbolConfiguration;
        if(isDay == 1) {
            if(code == 1000) {
                config = UIImage.SymbolConfiguration(paletteColors: [.yellow, .white]);
            } else {
                config = UIImage.SymbolConfiguration(paletteColors: [.white, .yellow, .white]);
            }
        } else {
            config = UIImage.SymbolConfiguration(paletteColors: [.darkGray, .white, .white]);
        }
        return config;
    }
    
    static func getIconName(_ code: Int, _ isDay: Int) -> String {
        var iconName = "";
        switch code {
        case 1000: // sunny or clear
            iconName = "sun.max.circle.fill";
            break;
        case 1003,1006,1009: // partly cloudy, cloudy, overcast
            iconName = "cloud.sun.fill"
            break;
        case 1183, 1189, 1195: // light rain, moderate rain, heavy rain
            iconName = "cloud.sun.rain.fill"
            break;
        case 1213, 1219, 1225: // light snow, moderate snow, heavy snow
            iconName = "cloud.snow.fill"
            break;
        case 1255: // light snow shower
            iconName = "cloud.snow.circle"
            break;
        case 1198, 1201: // light freezing rain , moderate or heavy freezing
            iconName = "cloud.rain.circle"
            break;
        default:
            iconName = "cloud.sun.rain.fill";
        }
        if(isDay == 0) {
            iconName = iconName.replacingOccurrences(of: "sun", with: "moon");
            iconName = iconName.replacingOccurrences(of: "max.", with: "");
        }
        
        return iconName;
    }
}
