
//
//  ViewController.swift
//  virtualTourist
//
//  Created by Manson Jones on 2/23/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import MapKit
import UIKit
import CoreData

class VirtualTouristViewController: UIViewController,
    MKMapViewDelegate {

    var photos: [FlickrPhoto] = [FlickrPhoto]()
    
    var pins = [MKAnnotation]()
    
    var pinLocations = [Location]()
    
    let regionRadius: CLLocationDistance = 1000
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editPins")
        let initialLocation = CLLocation(latitude: 34.0481, longitude: -118.5256)
        
        // Core Data Step ?
        // pins = fetchAllPins()
        
        centerMapOnLocation(initialLocation)
        FlickrClient.sharedInstance().getPhotosFromLatLonSearch(34.0481, longitude: -118.5256)
            { (photos, error) -> Void in
            if let photos = photos {
                self.photos = photos
                print("The number of Photos is:", self.photos.count)
            } else {
                print("Download of Flickr Photo failed")
                }
        }
        
        
       // FlickClient.sharedgetPhotosFromLatLonSearch(latitude : 1.23, longitude : 4.56)

      //  let annotation = MKAnnotation(CLLocation(latitude: 21.282778, longitude: -157.82944))
      //  mapView.addAnnotation(annotation)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // The placement of this pin is temporay.
        // It allows a way to set up the code for responding to the pin tap
        // until I create a way to create a pin on the map by holding
        /*
        let latitude = 34.0481
        let longitude = -118.5256
        let annotation = buildAnnotation(latitude, longitude: longitude)
        
        self.mapView.addAnnotation(annotation)
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }

    func fetchAllLocations() -> [Location] {

        // Create the Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        
        // Create the Fetch Request
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Location]
        } catch let error as NSError {
            print("Error in fetchAllPins(): \(error)")
            return [Location]()
        }
    
    }
    
    func insertNewPin(pin: MKAnnotation) {
        pins.insert(pin, atIndex: 0)
        
        // add the equivalent of getting the index path and inserting the
        // row in the table view, except for a map
    }
    
    /*
    private func buildAnnotation(latitude: Double, longitude: Double) -> MKPointAnnotation {

        let annotation = MKPointAnnotation()
        let lat = CLLocationDegrees(latitude)
        let lon = CLLocationDegrees(longitude)
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.title = "title"
        annotation.subtitle = "sub-title"
        return annotation
    }
    */    

    // MARK : MapKit Delegate Functions
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.cyanColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
            pinView!.pinTintColor = UIColor.greenColor()
        }
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control == view.rightCalloutAccessoryView) {
            print(" go to the Collection View Controller")
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("selected annotation view")
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

    @IBAction func handleLongPressGesture(sender: UILongPressGestureRecognizer) {
        print("Long Press Gesture Recognizer")
        
        
        let touchPoint = sender.locationInView(mapView)
        let newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        
        let newPin = Location(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)
    
        pinLocations.append(newPin)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        
        print(" size of pins array is:", pinLocations.count)
        
        let testAnnotation = newPin.pin!
        self.mapView.addAnnotation(testAnnotation)

    }
    
}

