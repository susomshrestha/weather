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
    
    public let locationManager = CLLocationManager();
    
    @IBOutlet weak var tableView: UITableView!;
    
    var locations: [LocationModel] = [];
    
    var savedLocation: LocationModel?;
    
    var annotation: MapAnnotation?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self;
        
        locationManager.requestWhenInUseAuthorization();
        
        //        addAnnotation(location: CLLocation(latitude: 23.0130, longitude: -81.1994));
        
        initializeTableView();
    }
    
    func initializeTableView() {
        tableView.dataSource = self;
        tableView.delegate = self;
    }
    
    func addAnnotation(annotation: MapAnnotation) {
        mapView.addAnnotation(annotation);
    }
    
    func setupMap(_ latitude: Double, _ longitude: Double, recenter: Bool = false) {
        mapView.delegate = self;
        
        //        mapView.showsUserLocation = true;
        
        // 43.0130, -81.1994 (fanshawe location)
        let location = CLLocation(latitude: latitude, longitude: longitude);
        if(!recenter) {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true);
            return;
        }
        
        mapView.setCenter(location.coordinate, animated: true);
        
        //        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        //
        //        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 100000), animated: true);
    }
    
    @IBAction func onAddPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToAddLocationScreen", sender: self)
    }
    
    
    @IBAction func unwindToMain(_ sender: UIStoryboardSegue) {
        if let location = savedLocation,
           let annotation = self.annotation{
            locations.append(location);
            tableView.reloadData();
            
            addAnnotation(annotation: annotation);
        }
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
        content.secondaryText = "\(item.temp) C (H: \(item.highTemp) L: \(item.lowTemp))"
        content.image = UIImage(systemName: item.image);
        
        cell.contentConfiguration = content;
        
        return cell;
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mapView.setCenter(self.locations[indexPath.row].coordinate, animated: true)
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
        
        // custome property so casting to MyAnnotation
        if let annotation = annotation as? MapAnnotation {
            // add glyph text
            view.glyphText = annotation.glyph;
            
            // add image on left of marker view
            let image = UIImage(systemName: annotation.iconName ?? "");
            view.leftCalloutAccessoryView = UIImageView(image: image);
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

class MapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D;
    var title: String?;
    var subtitle: String?;
    var glyph: String?;
    var iconName: String?;
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, iconName: String, gylph: String? = nil) {
        self.coordinate = coordinate;
        self.title = title;
        self.subtitle = subtitle;
        self.glyph = gylph;
        self.iconName = iconName;
        
        super.init();
    }
}

