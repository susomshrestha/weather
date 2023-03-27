//
//  Location.swift
//  weather
//
//  Created by Susom Shrestha on 2023-03-26.
//

import Foundation
import CoreLocation

extension ViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.requestLocation();
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation :CLLocation = locations[0] as CLLocation;
        
        manager.stopUpdatingLocation();
        
        setupMap(userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        //        print("user latitude = \(userLocation.coordinate.latitude)")
        //        print("user longitude = \(userLocation.coordinate.longitude)")
        
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
//            if (error != nil){
//                print("error in reverseGeocode")
//            }
//            let placemark = placemarks! as [CLPlacemark]
//            if placemark.count>0{
//                let placemark = placemarks![0]
//                print(placemark.locality!)
//                //                print(placemark.administrativeArea!)
//                print(placemark.country!)
//                self.searchWeather(location: "\(String(describing: placemark.location)) \(String(describing: placemark.country))")
//
//            }
//        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
