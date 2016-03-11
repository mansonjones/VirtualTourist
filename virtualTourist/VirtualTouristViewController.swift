//
//  ViewController.swift
//  virtualTourist
//
//  Created by Manson Jones on 2/23/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import MapKit
import UIKit

class VirtualTouristViewController: UIViewController, MKMapViewDelegate {

    
    let regionRadius: CLLocationDistance = 1000
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editPins")
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.82944)
        centerMapOnLocation(initialLocation)
        FlickrClient.sharedInstance().getPhotosFromLatLonSearch(1.23, longitude: 4.56)
       // FlickClient.sharedgetPhotosFromLatLonSearch(latitude : 1.23, longitude : 4.56)

      //  let annotation = MKAnnotation(CLLocation(latitude: 21.282778, longitude: -157.82944))
      //  mapView.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // Mark: - Actions
    func editPins() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneEditingPins")
        // TODO: Add code to slide up the "Tap Pins To Delete" Bar
    }
    
    func doneEditingPins() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editPins")
        // TODO: Add code to slide down the "Tap Pins to Delete" Bar
        // and delete the pins that were selected
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
        regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}

