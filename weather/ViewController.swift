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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupMap();
        
        addAnnotation(location: CLLocation(latitude: 43.0130, longitude: -81.1994))
    }
    
    func addAnnotation(location: CLLocation) {
        let annotation = MyAnnotation(coordinate: location.coordinate, title: "Title", subtitle: "Sub Title", gylph: "W");
        
        mapView.addAnnotation(annotation);
    }
    
    func setupMap() {
        mapView.delegate = self;
        
        // 43.0130, -81.1994
        let location = CLLocation(latitude: 43.0130, longitude: -81.1994);
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true);
        
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 100000), animated: true);
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

