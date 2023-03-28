//
//  AddLocationViewController.swift
//  weather
//
//  Created by Susom Shrestha on 2023-03-26.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var tfLocation: UITextField!;
    
    @IBOutlet weak var labelCity: UILabel!;
    @IBOutlet weak var labelCountry: UILabel!;
    
    @IBOutlet weak var labelTemperature: UILabel!;
    @IBOutlet weak var labelCondition: UILabel!;
    @IBOutlet weak var labelDegree: UILabel!;
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnSwitch: UIButton!;
    
    @IBOutlet weak var viewMain: UIView!;
    
    var tempC: Double = 0.0;
    var tempF: Double = 0.0;
    var isCelcius: Bool = true;
    
    var weatherResponse = WeatherResponse(location: nil, current: nil, forecast: nil);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfLocation.delegate = self;
        initUI();
    }
    
    func initUI() {
        //        viewMain.backgroundColor = UIColor.black;
        labelCountry.text = "Search to see weather"
        labelDegree.isHidden = true;
        btnSwitch.isHidden = true;
    }
    
    func searchWeather(location: String) {
        Weather.searchWeather(location: location) { weatherRes in
            self.weatherResponse = weatherRes;
            self.showWeatherData(weatherRes);
        }
    }
    
    func showWeatherData(_ weather: WeatherResponse) {
        if let current = weather.current, let location = weather.location {
            tempC = current.temp_c;
            tempF = current.temp_f;
            
            // set temperature and show degree text
            setLabelTemperature();
            
            labelDegree.isHidden = false;
            btnSwitch.isHidden = false;
            
            // set city and country
            labelCity.text = location.name;
            labelCountry.text = "\(location.region)  \(location.country)";
            
            // set weather condition
            labelCondition.text = current.condition.text;
            
            // update icon and background
            updateIconAndBg(current: current);
        }
    }
    
    func setLabelTemperature() {
        if (isCelcius) {
            labelTemperature.text = String(tempC);
            labelDegree.text = "° C";
            return;
        }
        labelTemperature.text = String(tempF);
        labelDegree.text = "° F";
    }
    
    func updateIconAndBg(current: Current) {
        updateBgAndColors(isDay: current.is_day);
        imageView.preferredSymbolConfiguration = Weather.getIconCongiguration(current.condition.code, current.is_day);
        imageView.image = UIImage(systemName: Weather.getIconName(current.condition.code, current.is_day));
    }
    
    func updateBgAndColors(isDay: Int) {
        if(isDay == 1) {
            viewMain.backgroundColor = UIColor.init(red: 141 / 255, green: 205 / 255, blue: 228 / 255, alpha: 1);
            return;
        }
        viewMain.backgroundColor = UIColor.init(red: 29 / 255, green: 38 / 255, blue: 83 / 255, alpha: 1);
        labelDegree.textColor = UIColor.white;
    }
    
    @IBAction func onSearchPressed(_ sender: UIButton?) {
        guard let location = tfLocation.text else {
            return;
        }
        searchWeather(location: location);
    }
    
    @IBAction func onSwitchPressed(_ sender: UIButton) {
        isCelcius = !isCelcius;
        setLabelTemperature();
    }
    
    
    @IBAction func onSavePressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToMain", sender: self);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToMain") {
            let mainViewController = segue.destination as! ViewController;
            if let location = weatherResponse.location,
               let current = weatherResponse.current,
               let forecast = weatherResponse.forecast {
                mainViewController.savedLocation = LocationModel(
                    name: ("\(location.name) \(location.country)"),
                    temp: (current.temp_c),
                    highTemp: (forecast.forecastday[0].day.maxtemp_c),
                    lowTemp: (forecast.forecastday[0].day.mintemp_c),
                    image: Weather.getIconName(current.condition.code, current.is_day),
                    coordinate: CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
                );
                mainViewController.annotation = MapAnnotation(
                    coordinate: CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon),
                    title: "\(current.temp_c)",
                    subtitle: "Temp: \(current.temp_c), Feels Like: \(current.feelslike_c)",
                    iconName: Weather.getIconName(current.condition.code, current.is_day),
                    temp: current.temp_c,
                    gylph: "W")
            }
            
        }
    }
    
    
    @IBAction func onCancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true);
    }
}

extension AddLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true);
        textField.resignFirstResponder();
        searchWeather(location: textField.text ?? "");
        return true;
    }
}
