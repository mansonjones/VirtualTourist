
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

class TravelLocationsViewController: UIViewController,
    MKMapViewDelegate {
    
    var annotations = [MKPointAnnotation]()
    
    var pinLocations = [Location]()
    
    let regionRadius: CLLocationDistance = 1000 
    
    let initialLocation = CLLocation(latitude: 34.0481, longitude: -118.5256)
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        restoreMapRegion(false)
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editPins")
        
        /* self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editPins") */
        // This is for debugging purposes only
        let debugButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "debug")
        navigationItem.rightBarButtonItems = [editButton, debugButton]
       // let initialLocation = CLLocation(latitude: 34.0481, longitude: -118.5256)
        
        // Core Data Step ?
        // annotations = fetchAllPins()
        // once all the annotations are loaded from coredata,
        // call annotations.append(annotation)
        
        // centerMapOnLocation(initialLocation)
    }
    
    var filePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("mapRegionArchive").path!
    }

    func saveMapRegion() {
        // Place the "center" and "span" of the map into a dictionary
        // The "span" is the width and height of the map in degrees.
        // It represents the zoom level of the map
        let dictionary = [
            "latitude" : mapView.region.center.latitude,
            "longitude" : mapView.region.center.longitude,
            "latitudeDelta" : mapView.region.span.latitudeDelta,
            "longitudeDelta" : mapView.region.span.longitudeDelta
        ]
        
        // Archive the dictionary into the filePath
        NSKeyedArchiver.archiveRootObject(dictionary, toFile: filePath)
    }
    
    func restoreMapRegion(animated: Bool) {
        // if we can unarchive the dictionary, we will use it to set the map back to its
        // previous center and span
        
        if let regionDictionary = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [String : AnyObject] {
            
            let longitude = regionDictionary["longitude"] as! CLLocationDegrees
            let latitude = regionDictionary["latitude"] as! CLLocationDegrees
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let longitudeDelta = regionDictionary["latitudeDelta"] as! CLLocationDegrees
            let latitudeDelta = regionDictionary["longitudeDelta"] as! CLLocationDegrees
            let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            
            let savedRegion = MKCoordinateRegion(center: center, span: span)
            
            print("lat: \(latitude), lon: \(longitude), latD: \(latitudeDelta), lonD: \(longitudeDelta)")
            
            mapView.setRegion(savedRegion, animated: animated)
        }
        
        
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
        // TODO: This is where you will load in the zoom settings
    }
    
    override func viewWillDisappear(animated: Bool) {
        print(" Map View Attributes to save")
        // TODO: This is where the region data should be serialized.
        print("\(mapView.region)")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowPhotoAlbum" {
            let controller = segue.destinationViewController as! PhotoAlbumViewController
            // TODO: Set the latitude and longitude for the selected value
            controller.latitude = 34.0481
            controller.longitude = -118.5256
        }
    }
    
    func launchPhotoAlbum() {
        performSegueWithIdentifier("ShowPhotoAlbum", sender: self)
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
    
    func insertNewPin(pin: MKPointAnnotation) {
        annotations.insert(pin, atIndex: 0)
        
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
        
        
        print("viewForAnnotation")
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
           // pinView!.pinTintColor = UIColor.blueColor()
            // pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
            // pinView!.pinTintColor = UIColor.greenColor()
        }
        return pinView
    }
    
    // This delegate method is implemented to respond to taps.  It opens the collection view
    // and passes the latitude and longitude information to the collection view.
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped")
        if (control == view.rightCalloutAccessoryView) {
            print(" go to the Collection View Controller")
            // Here is where you would call launch the collection view
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("selected annotation view")
        launchPhotoAlbum()
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("regionDidChangeAnimated")
        saveMapRegion()
    }
    
    // Mark: - Actions
    func editPins() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneEditingPins")
        // TODO: Add code to slide up the "Tap Pins To Delete" Bar
    }
    
    func debug() {
        print("Debug")
                // let initialLocation = CLLocation(latitude: 34.0481, longitude: -118.5256)
       // let latitude = 34.0481
       // let longitude = -118.5256
        
        launchPhotoAlbum()
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
        if sender.state == .Began {
            
            let touchPoint = sender.locationInView(mapView)
            let newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            
            let newPin = Location(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)
            
            pinLocations.append(newPin)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            
            print(" size of pins array is:", pinLocations.count)
            
            // let testAnnotation = newPin.pin!
            self.mapView.addAnnotation(annotation)
        }
    }
    
}

