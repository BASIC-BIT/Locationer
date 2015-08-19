//
//  LocationDetailViewController.swift
//  Locationer
//
//  Created by CSSE Department on 7/21/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit
import GoogleMaps
class LocationDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var descLabel : UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var isFavLabel: UILabel!
    var location : Location?
    let kShowOnMapFromDetailSegueIdentifier = "showOnMapFromDetailSegueIdentifier"
    let kToEditLocationSegueIdentifier = "toEditLocationSegueIdentifier"

    @IBOutlet weak var addressLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "pressedEdit:")
        self.addressLabel.text = ""
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.configureView()
    }
    
    @IBAction func pressedGoToOnMap(sender: AnyObject) {
        self.performSegueWithIdentifier(kShowOnMapFromDetailSegueIdentifier, sender: self)
    }
    @IBAction func pressedOpenInGoogle(sender: AnyObject) {
//        UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.google.com/maps?q=London")!)
//        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
//            UIApplication.sharedApplication().openURL(NSURL(string:
//                "comgooglemaps://?center=40.765819,-73.975866&zoom=14")!)
//        } else {
//            NSLog("Can't use comgooglemaps://");
//        }
//         opens to location but without marker... not ideal
//        var urlToSend = "https://www.google.com/maps/@"
        
        //TODO: Add reverse geocoading so that you can with directions to the location 
        //FIXME: Implement google url scheme
        var urlToSend = "http://maps.apple.com/?ll="
        urlToSend += self.location!.lat.stringValue
        urlToSend += ","
        urlToSend += self.location!.lon.stringValue
//        urlToSend += ",18z"
        urlToSend += "z=18"
        UIApplication.sharedApplication().openURL(NSURL(string: urlToSend)!)
        
//        UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/?q=cupertino")!)
        

    }

    @IBAction func pressedEdit(sender: AnyObject) {
       self.performSegueWithIdentifier(kToEditLocationSegueIdentifier, sender: self)
        
    }

    func configureView() {
        // Update the user interface for the detail item.
            if let nl = self.nameLabel {
                nl.text = location!.name
            }
            if let dl = self.descLabel {
                dl.text = location!.desc
            }
        if let tag = self.location?.tag{
            self.tagLabel.text = tag.name
            self.tagLabel.textColor = Util.colorDictionary[tag.color]
        } else {
            self.tagLabel.text = ""
        }
        if let fl = self.isFavLabel {
//            fl.text = location?.isFavorite.boolValue.description
            let trueText = "This location is a favorite"
            let falseText = "This location is not a favorite"
            if((location?.isFavorite.boolValue) == nil || location?.isFavorite.boolValue == false){
                fl.text = falseText
            } else {
                fl.text = trueText
            }
        }
        if let address = self.location?.address{
            self.addressLabel.text = address
        }
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == kShowOnMapFromDetailSegueIdentifier){
            (segue.destinationViewController as! MapDisplayViewController).detailLocationToAppearAt = CLLocationCoordinate2D(latitude: location!.lat.doubleValue, longitude: location!.lon.doubleValue)
        }
        if(segue.identifier == kToEditLocationSegueIdentifier){
            let destination = segue.destinationViewController as! EditLocationViewController
            destination.location = self.location
            destination.isEditMode = true

            
        }
    }


}

