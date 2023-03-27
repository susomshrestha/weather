//
//  DetailViewController.swift
//  weather
//
//  Created by Susom Shrestha on 2023-03-27.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var locationLabel: UILabel!;
    @IBOutlet weak var labelCondition: UILabel!;
    @IBOutlet weak var tempLabel: UILabel!;
    @IBOutlet weak var highLowLabel: UILabel!;
    @IBOutlet weak var degreeLabel: UILabel!;
    
    @IBOutlet weak var tableView: UITableView!;
    
    var forecasts: [ForecastDay] = [];
    
    var latitude: Double?;
    var longitude: Double?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initializeTableView();
        getForecast();
    }
    
    func getForecast() {
        if let latitude = self.latitude,
           let longitude = self.longitude {
            Weather.searchWeather(location: "\(latitude),\(longitude)", day: 7) { res in
                self.populateWeatherData(weatherResponse: res);
            }
        }
    }
    
    func initializeTableView() {
        tableView.dataSource = self;
    }
    
    func populateWeatherData(weatherResponse: WeatherResponse) {
        if let location = weatherResponse.location,
           let current = weatherResponse.current,
           let forecast = weatherResponse.forecast {
            locationLabel.text = "\(location.name) \(location.country)";
            labelCondition.text = current.condition.text;
            tempLabel.text = "\(current.temp_c)";
            highLowLabel.text = "High: \(forecast.forecastday[0].day.maxtemp_c) | Low: \(forecast.forecastday[0].day.mintemp_c)";
            
            populateForecast(forecast: forecast);
        }
    }
    
    func populateForecast(forecast: Forecast) {
        for cast in forecast.forecastday {
            forecasts.append(cast);
        }
        tableView.reloadData();
    }
    
    
    @IBAction func onDonePressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationItemCell");
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationItemCell", for: indexPath);
        let item = forecasts[indexPath.row];
        
        var content = cell.defaultContentConfiguration();
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        
        // Set Date Format
        dateFormatter.dateFormat = "yyyy-MM-dd";
        
        content.text = Calendar.current.weekdaySymbols[Calendar.current.component(.weekday, from: dateFormatter.date(from: item.date) ?? Date()) - 1];
        
        content.secondaryText = "\(item.day.avgtemp_c) C";
        content.image = UIImage(systemName: Weather.getIconName(item.day.condition.code, 1));
        
        cell.contentConfiguration = content;
        
        return cell;
    }
}
