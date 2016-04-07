//
//  TravelLocationsVC.swift
//  virtualTourist
//
//  Created by Manson Jones on 2/23/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import MapKit
import UIKit
import CoreData

class TravelLocationsMapVC: UIViewController,
MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    var selectedPin : Pin!
    var isInDeleteMode = false
    var tapPinsToDeleteLabel: UILabel!
    
    let regionRadius: CLLocationDistance = 1000
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        fetchedResultsController.delegate = self
        
        restoreMapRegion(false)
        createTapPinsToDeleteLabel()
        tapPinsToDeleteLabel.hidden = true
        
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editPins")
        
        self.mapView.addAnnotations(fetchAllPins())
    }
    
    // MARK: - Fetched Results Controller Delegate
    // These are the four methods that the Fetched Results Controller invokes on this
    // view controller
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
        print(" controllerWillChangeContent")
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            let pinObject = anObject as! Pin
            self.mapView.addAnnotation(pinObject)
        case .Delete:
            print("Delete")
            let pinObject = anObject as! Pin
            self.mapView.removeAnnotation(pinObject)
            // question. Should I save context here?
        default:
            return
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        print("didChangeContent")
    }
    
    var filePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("mapRegionArchive").path!
    }
    
    
    // MARK: - Core Data Convenience
    
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    // MARK: - Fetched Results Controller
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        // Create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        
        // Add a sort descriptor. This enforces a sort order on the results that are generated
        // In this case we want the events sored by their timeStamps.
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: false)]
        
        // Create the Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Return the fetched results controller. It will be the value of the lazy variable
        return fetchedResultsController
    } ()
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    // MARK : MapKit Delegate Functions
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.animatesDrop = true
            // pinView!.pinTintColor = UIColor.blueColor()
            // pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView?.animatesDrop = true
            pinView!.annotation = annotation
            // pinView!.pinTintColor = UIColor.greenColor()
        }
        return pinView
    }
    
    // This delegate method is implemented to respond to taps.  It opens the collection view
    // and passes the latitude and longitude information to the collection view.
    
    /*
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control == view.rightCalloutAccessoryView) {
    
            // Here is where you would call launch the collection view
        }
    }
    */
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        selectedPin = view.annotation as! Pin
        if isInDeleteMode {
            sharedContext.deleteObject(selectedPin)
        } else {
            launchPhotoAlbum()
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        saveMapRegion()
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
            
            mapView.setRegion(savedRegion, animated: animated)
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPhotoAlbum" {
            let controller = segue.destinationViewController as! PhotoAlbumVC
            
            // TODO: use fetchResultsController to get the selected pin
            // let location = fetchedResultsController.objectAtIndexPath()
            controller.location = selectedPin
        }
    }
    
    func launchPhotoAlbum() {
        performSegueWithIdentifier("ShowPhotoAlbum", sender: self)
    }
    
    // Mark: - Actions
    func editPins() {
        print(" **** Editing Pins")
        isInDeleteMode = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneEditingPins")
        // TODO: Add code to slide up the "Tap Pins To Delete" Bar
        self.tapPinsToDeleteLabel.hidden = false
        self.tapPinsToDeleteLabel.frame.origin.y = self.view.frame.height - 50

        
    }
    
    func doneEditingPins() {
        print(" *** Done Editing Pins")
        isInDeleteMode = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editPins")
        self.tapPinsToDeleteLabel.hidden = true
        // TODO: Add code to slide down the "Tap Pins to Delete" Bar
        // and delete the pins that were selected
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func handleLongPressGesture(sender: UILongPressGestureRecognizer) {
        let pressPoint = sender.locationInView(mapView)
        let coordinate: CLLocationCoordinate2D = mapView.convertPoint(pressPoint, toCoordinateFromView: mapView)
        
        if sender.state == .Began {
            let pin = MKPointAnnotation()
            pin.coordinate = coordinate
            let _ = Pin(pinLatitude: coordinate.latitude, pinLongitude: coordinate.longitude, context: self.sharedContext)
            // question: Should I save context here?
        }
    }
    
    func fetchAllPins() -> [Pin] {
        
        do {
        try fetchedResultsController.performFetch()
        } catch {
        print("error")
            
        }
        
        let fetchedPins = fetchedResultsController.fetchedObjects as! [Pin]
        return fetchedPins
    }
    
    func createTapPinsToDeleteLabel() {
        tapPinsToDeleteLabel = UILabel(frame: CGRectMake(0,0,200,21))
        tapPinsToDeleteLabel.center = CGPointMake(160,284)
        tapPinsToDeleteLabel.textAlignment = .Center
        tapPinsToDeleteLabel.text = "Tap Pins To Delete"
        tapPinsToDeleteLabel.textColor = UIColor.whiteColor()
        tapPinsToDeleteLabel.backgroundColor = UIColor.redColor()
        tapPinsToDeleteLabel.alpha = 0.5
        self.view.addSubview(tapPinsToDeleteLabel)
    }
}

