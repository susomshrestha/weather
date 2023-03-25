//
//  ViewController.swift
//  weather
//
//  Created by Susom Shrestha on 2023-03-22.
//

import UIKit;
import MapKit;

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!;
    
    private let locationManger = CLLocationManager();
    
    @IBOutlet weak var tableView: UITableView!;
    
    var locations: [LocationItem] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManger.requestWhenInUseAuthorization();
        
        setupMap();
        
        addAnnotation(location: CLLocation(latitude: 43.0130, longitude: -81.1994));
        
        tableView.dataSource = self;
        
        addDefaultData();
    }
    
    func addAnnotation(location: CLLocation) {
        let annotation = MyAnnotation(coordinate: location.coordinate, title: "Title", subtitle: "Sub Title", gylph: "W");
        
        mapView.addAnnotation(annotation);
    }
    
    func setupMap() {
        mapView.delegate = self;
        
        mapView.showsUserLocation = true;
        
        // 43.0130, -81.1994
        let location = CLLocation(latitude: 43.0130, longitude: -81.1994);
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true);
        
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 100000), animated: true);
    }
    
    func addDefaultData() {
        locations.append(LocationItem(name: "Vancouver", temp: 22, highTemp: 23, lowTemp: 21, image: "sunny"));
        locations.append(LocationItem(name: "London", temp: 14, highTemp: 17, lowTemp: 10, image: "sunny"));
        locations.append(LocationItem(name: "Toronto", temp: 21, highTemp: 25, lowTemp: 17, image: "sunny"));
    }
    
    @IBAction func onAddPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Location", message: "Enter location to add.", preferredStyle: .alert);
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter Location";
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel));
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { UIAlertAction in
            if let tfTitle = alertController.textFields?[0] as? UITextField {
                self.locations.append(LocationItem(name: tfTitle.text ?? "", temp: 21, highTemp: 23, lowTemp: 20, image: "sun.cloud.fill"));
                self.tableView.reloadData();
            }
        }));
        
        self.present(alertController, animated: true);
    }
}

extension ViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationItemCell");
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationItemCell", for: indexPath);
        let item = locations[indexPath.row];
        
        var content = cell.defaultContentConfiguration();
        content.text = item.name;
        content.secondaryText = "\(item.temp) C (H: \(item.highTemp) L: \(item.lowTemp)"
        content.image = UIImage(systemName: "sun.min");
        
        cell.contentConfiguration = content;
        
        return cell;
    }
    
    
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "weather";
        
        var view: MKMarkerAnnotationView;
        
        // if we have reusable view use the view
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation;
            
            view = dequeuedView;
            return view;
        }
        
        // cerate new view if no reusable view
        view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        
        view.canShowCallout = true;
        
        // position of the view
        view.calloutOffset = CGPoint(x: 0, y: 010)
        
        // add button on right side of marker view
        let button = UIButton(type: .detailDisclosure)
        view.rightCalloutAccessoryView = button;
        
        // add image on left of marker view
        let image = UIImage(systemName: "graduationcap.circle.fill");
        view.leftCalloutAccessoryView = UIImageView(image: image);
        
        // add glyph text
        // custome property so casting to MyAnnotation
        if let annotation = annotation as? MyAnnotation {
            view.glyphText = annotation.glyph;
        }
        
        
        return view;
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let coordinates = view.annotation?.coordinate else {
            return;
        }
        
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
        ]
        
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates));
        mapItem.openInMaps(launchOptions: launchOptions);
    }
}

class MyAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D;
    var title: String?;
    var subtitle: String?;
    var glyph: String?;
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, gylph: String? = nil) {
        self.coordinate = coordinate;
        self.title = title;
        self.subtitle = subtitle;
        self.glyph = gylph;
        
        super.init();
    }
}

struct LocationItem {
    let name: String;
    let temp: Double;
    let highTemp: Double;
    let lowTemp: Double;
    let image: String;
}

