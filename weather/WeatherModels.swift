//
//  WeatherModels.swift
//  weather
//
//  Created by Susom Shrestha on 2023-03-26.
//

import Foundation

struct WeatherResponse: Decodable {
    let location: Location?;
    let current: Current?;
    let forecast: Forecast?;
}

struct Forecast: Decodable {
    let forecastday: [ForecastDay];
}

struct ForecastDay: Decodable {
    let date: String;
    let day: Day;
}

struct Day: Decodable {
    let maxtemp_c: Double;
    let maxtemp_f: Double;
    let mintemp_c: Double;
    let mintemp_f: Double;
    let avgtemp_c: Double;
    let avgtemp_f: Double;
    let condition: Condition;
}

struct Location: Decodable {
    let name: String;
    let region: String;
    let country: String;
    let localtime: String;
    let lat: Double;
    let lon: Double;
}

struct Current: Decodable {
    let temp_c: Double;
    let temp_f: Double;
    let condition: Condition;
    let is_day: Int;
    let feelslike_c: Double;
    let feelslike_f: Double;
}

struct Condition: Decodable {
    let text: String;
    let code: Int;
}
