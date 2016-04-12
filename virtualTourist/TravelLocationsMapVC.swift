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
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editPins")
        
        mapView.addAnnotations(fetchAllPins())
    }
    
    
    override func viewWillLayoutSubviews() {
        if isInDeleteMode {
            tapPinsToDeleteLabel.frame.origin.y = view.frame.height - 50
        }
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
            mapView.addAnnotation(pinObject)
            CoreDataStackManager.sharedInstance().saveContext()
        case .Delete:
            let pinObject = anObject as! Pin
            mapView.removeAnnotation(pinObject)
            CoreDataStackManager.sharedInstance().saveContext()
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
        } else {
            pinView?.animatesDrop = true
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    // This delegate method is implemented to respond to taps.
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        selectedPin = view.annotation as! Pin
        if doesPinExistInCoreData(selectedPin) {
            if isInDeleteMode {
                sharedContext.deleteObject(selectedPin)
            } else {
                mapView.deselectAnnotation(selectedPin, animated: false)
                launchPhotoAlbum()
            }
        }
    }
    
    func doesPinExistInCoreData(pin: Pin) -> Bool {
        // Verify that the selected Pin exists in Core Data using the hashNumber
        // Create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        fetchRequest.predicate = NSPredicate(format: "hashNumber == %@", pin.hashNumber)
        // Add a sort descriptor. This enforces a sort order on the results that are generated
        // In this case we want the events sored by their timeStamps.
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: false)]
        
        // Create the Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Return the fetched results controller. It will be the value of the lazy variable
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("error")
        }
        let fetchedPins = fetchedResultsController.fetchedObjects as! [Pin]
        
        if (fetchedPins.count == 1) {
            return true
        }
        return false
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
            
            controller.location = selectedPin
        }
    }
    
    func launchPhotoAlbum() {
        performSegueWithIdentifier("ShowPhotoAlbum", sender: self)
    }
    
    // Mark: - Actions
    func editPins() {
        isInDeleteMode = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneEditingPins")
        tapPinsToDeleteLabel.hidden = false
        tapPinsToDeleteLabel.frame.origin.y = view.frame.height - 50
        
        
    }
    
    func doneEditingPins() {
        isInDeleteMode = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editPins")
        tapPinsToDeleteLabel.hidden = true
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
            let _ = Pin(pinLatitude: coordinate.latitude,
                pinLongitude: coordinate.longitude,
                pinHashNumber: pin.hash,
                context: self.sharedContext)
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
        view.addSubview(tapPinsToDeleteLabel)
    }
}

