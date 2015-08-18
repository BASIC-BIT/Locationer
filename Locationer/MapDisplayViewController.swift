//
//  MapDisplayViewController.swift
//  Locationer
//
//  Created by CSSE Department on 7/28/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps

class MapDisplayViewController: UIViewController, GMSMapViewDelegate, NSFetchedResultsControllerDelegate , CLLocationManagerDelegate{
    
    let saveSegueIdentifier = "saveSegueIdentifier"
    let tableSegueIdentifier = "tableSegueIdentifier"
    var managedObjectContext: NSManagedObjectContext? = nil
    var lastPressedMarker : GMSMarker? = nil
    var quickSaveMarker : GMSMarker? = nil
    var detailLocationToAppearAt : CLLocationCoordinate2D? = nil
    var locationManager : CLLocationManager? = nil
    var didFindMyLocation = false
    var holdDownMarkerOnMap = false
    let defaultZoom : Float = 10.0


    
//    @IBOutlet weak var addressLabel: UILabel!
//    
//    @IBAction func geoCode(sender: AnyObject) {
//
//        _reverseGeoCodeCoordination(self.mapView.camera.target)
//    }
    


    @IBOutlet weak var addressInputTextField: UITextField!
    
    @IBAction func pressedGoToOnMap(sender: AnyObject) {
        _forwardGeoCodeFromAddress(self.addressInputTextField.text)
    }
    
    func _forwardGeoCodeFromAddress(address : String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address, completionHandler: { (placeMarkers:[AnyObject]!, error : NSError!) -> Void in
            var isFirstPlaceMarker = true
            let aplaceMarkers = placeMarkers as! [CLPlacemark]
            if let first = aplaceMarkers.first {
                let camera = GMSCameraPosition.cameraWithTarget(first.location.coordinate, zoom: self.defaultZoom)
                self.mapView.camera = camera
            }
        })
    }
//    func _forwardgeo(address : String)->GMSCameraPosition? {
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(address, completionHandler: { (placeMarkers:[AnyObject]!, error : NSError!) -> Void in
//            var isFirstPlaceMarker = true
//            let aplaceMarkers = placeMarkers as! [CLPlacemark]
//            if let placemark = aplaceMarkers.first{
//                let cameraPosition : GMSCameraPosition? = GMSCameraPosition.cameraWithTarget(placemark.location.coordinate, zoom: 13)
//                return cameraPosition
//            } else {
//                return
//            }
//        })
//    }
//    
    @IBOutlet weak var mapView: GMSMapView!
    
    var addressResultFromGeocode : String? = nil
    func _reverseGeoCodeCoordination(coordinate: CLLocationCoordinate2D)->String?{
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate, completionHandler: { (response : GMSReverseGeocodeResponse!, error : NSError!) -> Void in
            if let address = response.firstResult(){
                let lines = address.lines as! [String]
                self.addressResultFromGeocode = join("\n", lines)
            } else {
                self.addressResultFromGeocode = nil
            }
        })
        return self.addressResultFromGeocode
    }
    var markers : [GMSMarker] {
        if _markers != nil{
            return _markers!
        }
        _markers = _returnMarkers()
        return _markers!
    }
    var _markers : [GMSMarker]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
        self.goToLastSavedButton.titleLabel?.numberOfLines = 0
        self.quickSaveButton.titleLabel?.numberOfLines = 0
//        self.goToLastSavedButton.titleLabel?.text = "go to \n last saved"

        // set up mapview
        self.mapView.delegate = self

        self.mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)

        // set up location manager
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        println("Void did load")
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let locationToStart = detailLocationToAppearAt{
            let camera = GMSCameraPosition.cameraWithLatitude(locationToStart.latitude, longitude: locationToStart.longitude, zoom: 15)
            self.mapView.camera = camera
            self.detailLocationToAppearAt = nil
        } else {
            // to center at user
            println("not detail loc")
            //FIXME: loads rose first then quickly changes to other location when data becomes available
            if let myLocation = self.mapView.myLocation{
                self.mapView.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: defaultZoom)

                println("I have a location")
            } else {
                println("couldn't find location")
                // to center at rose human
                var roseHulman = GMSCameraPosition.cameraWithLatitude(39.483464, longitude: -87.324142, zoom: defaultZoom)
                self.mapView.camera = roseHulman
            }
        }
        //FIXME markers dissapear and quickly reapear whenever loaded ; not as intended
        _markers = nil
        self.mapView.clear()
        for marker in markers{
            if marker.map == nil{
                marker.map = self.mapView
            }
        }
    

        println("did appear")
    }
    // MARK: - location delegate methods
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        self.mapView.myLocationEnabled = true
    }
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        let myLocation : CLLocation = change[NSKeyValueChangeNewKey] as! CLLocation
        self.mapView.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: defaultZoom)
        self.mapView.settings.myLocationButton = true
        
        didFindMyLocation = true
    }
    // MARK: - mapView functions
    func mapView(mapView: GMSMapView!, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        println("did hold")
        if let lastMarker = self.lastPressedMarker{
            lastMarker.map = nil;
        }
        let marker = GMSMarker(position: coordinate)
        marker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = self.mapView
        var snippet = "Press save to save this marker! \n"
        if let address = _reverseGeoCodeCoordination(coordinate){
            snippet += address
        }
        marker.snippet = snippet
        self.lastPressedMarker = marker
    }
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        mapView.selectedMarker = marker
        return true
    }
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
        _setQuickSaveMarker(position)
    }
    func _setQuickSaveMarker(position : GMSCameraPosition){

        let quickSaveMarker = GMSMarker()
        quickSaveMarker.icon = GMSMarker.markerImageWithColor(UIColor.blackColor())
        quickSaveMarker.position = position.target
        quickSaveMarker.title = "Quick Save Marker"
        quickSaveMarker.snippet = "this is the position that will be saved by pressing quicksave"
        quickSaveMarker.map = self.mapView
        self.quickSaveMarker = quickSaveMarker
        _reverseGeoCodeCoordination(quickSaveMarker.position)
    }
    func mapView(mapView: GMSMapView!, willMove gesture: Bool) {
        //FIXME: change graphical bug
        self.quickSaveMarker?.map = nil
        self.quickSaveMarker = nil
        

    }

    // MARK: - Private Functions
    func _returnMarkers()->[GMSMarker]{
        self._fetchedResultsController = nil
        let locations = self.fetchedResultsController.sections![0].objects as! [Location]
        var markerArray = [GMSMarker]()
        for savedLocation in locations{
            let markerLocation = CLLocationCoordinate2D(latitude: savedLocation.lat.doubleValue, longitude: savedLocation.lon.doubleValue)
            let marker = GMSMarker(position: markerLocation)
            marker.title = savedLocation.name
            var snippetText = savedLocation.desc
            if let address = savedLocation.address{
                snippetText += "\n"
                snippetText += address
            }
            marker.snippet = snippetText
            if let tag = savedLocation.tag{
                marker.icon = GMSMarker.markerImageWithColor(Util.colorDictionary[tag.color])

            }
        
            marker.appearAnimation = kGMSMarkerAnimationPop
            markerArray.append(marker)
            println("refreshed location with name \(savedLocation.name)")
        }
        // add qs marker to auto load marker database
        return markerArray

    }
    func _reloadMarkers(){
        _fetchedResultsController = nil
        _markers = nil
        self.mapView.clear()
        for marker in markers{
            if marker.map == nil{
                marker.map = self.mapView
            }
        }
    }
    // MARK: - Button Press Actions
    @IBOutlet weak var goToLastSavedButton: UIButton!
    
    @IBOutlet weak var quickSaveButton: UIButton!
    
    
    @IBAction func pressedListButton(sender: AnyObject) {
        self.performSegueWithIdentifier(tableSegueIdentifier, sender: self)
    }
    @IBAction func pressedSaveButton(sender: AnyObject) {
        if let validMarker =  self.lastPressedMarker{
            self.performSegueWithIdentifier(saveSegueIdentifier, sender: self)
        } else if let validMarker = self.quickSaveMarker{
            self.performSegueWithIdentifier(saveSegueIdentifier, sender: self)
        }
    }
    @IBAction func pressedQuickSave(sender: AnyObject) {
        if let marker = self.quickSaveMarker{
            let newLocation = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: CoreDataUtils.managedObjectContext()) as! Location
            newLocation.name = "Quick Saved Marker"
            newLocation.desc = "Enter a description of this marker here"
            newLocation.dateAdded = NSDate()
            newLocation.lat = marker.position.latitude
            newLocation.lon = marker.position.longitude
            newLocation.address = _reverseGeoCodeCoordination(marker.position)
            newLocation.isFavorite = NSNumber(bool: true)
            CoreDataUtils.saveContext()
            marker.map = self.mapView
        }
        self.quickSaveMarker?.map =  nil
        self.quickSaveMarker = nil


    }
    
    @IBAction func pressedGoToLastSaved(sender: AnyObject) {
        if let qsmarker = self.quickSaveMarker{
            self.mapView.camera = GMSCameraPosition.cameraWithLatitude(qsmarker.position.latitude, longitude: qsmarker.position.longitude, zoom: self.mapView.camera.zoom)
        }
    }
    @IBAction func pressedMenuButton(sender: AnyObject) {
        let ac = UIAlertController(title: "Choose a Map Type", message: nil, preferredStyle: .ActionSheet)
        let normalMapAction = UIAlertAction(title: "Normal Road Map", style: UIAlertActionStyle.Default) { (action : UIAlertAction!) -> Void in
            self.mapView.mapType = kGMSTypeNormal
        }
        ac.addAction(normalMapAction)
        let hybridMapAction = UIAlertAction(title: "Hybrid Map", style: UIAlertActionStyle.Default) { (action : UIAlertAction!) -> Void in
            self.mapView.mapType = kGMSTypeHybrid
        }
        ac.addAction(hybridMapAction)
        let satelliteMapAction = UIAlertAction(title: "Satellite Map", style: UIAlertActionStyle.Default) { (action : UIAlertAction!) -> Void in
            self.mapView.mapType = kGMSTypeSatellite
        }
        ac.addAction(satelliteMapAction)
        let terrainMapAction = UIAlertAction(title: "Terrain Map", style: UIAlertActionStyle.Default) { (action : UIAlertAction!) -> Void in
            self.mapView.mapType = kGMSTypeTerrain
        }
        ac.addAction(terrainMapAction)
        let cancelMapAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        ac.addAction(cancelMapAction)
        self.presentViewController(ac, animated: true, completion: nil)
    }

    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: CoreDataUtils.managedObjectContext())
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataUtils.managedObjectContext(), sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == saveSegueIdentifier{
            (segue.destinationViewController as! EditLocationViewController).marker = (self.lastPressedMarker != nil) ? self.lastPressedMarker : self.quickSaveMarker
        }
        if segue.identifier == tableSegueIdentifier{
//            (segue.destinationViewController as! LocationsTableViewController).navigationItem = self.navigationItem
        }
    }

}
