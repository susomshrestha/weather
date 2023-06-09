//
//  LocationModel.swift
//  weather
//
//  Created by Susom Shrestha on 2023-03-25.
//

import Foundation
import CoreLocation

struct LocationModel {
    let name: String;
    let temp: Double;
    let highTemp: Double;
    let lowTemp: Double;
    let image: String;
    let coordinate: CLLocationCoordinate2D;
}
