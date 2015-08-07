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
    @IBOutlet weak var isFavLabel: UILabel!
    var location : Location?
    let kShowOnMapFromDetailSegueIdentifier = "showOnMapFromDetailSegueIdentifier"

    @IBAction func pressedGoToOnMap(sender: AnyObject) {
        self.performSegueWithIdentifier(kShowOnMapFromDetailSegueIdentifier, sender: self)
    }

    func configureView() {
        // Update the user interface for the detail item.
            if let nl = self.nameLabel {
                nl.text = location!.name
            }
            if let dl = self.descLabel {
                dl.text = location!.desc
            }
        if let fl = self.isFavLabel {
//            fl.text = location?.isFavorite.boolValue.description
            let trueText = "This location is a favorite"
            let falseText = "This location is not a favorite"
            if((location?.isFavorite.boolValue) != nil){
                fl.text = trueText
            } else {
                fl.text = falseText
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == kShowOnMapFromDetailSegueIdentifier){
            (segue.destinationViewController as! MapDisplayViewController).detailLocationToAppearAt = CLLocationCoordinate2D(latitude: location!.lat.doubleValue, longitude: location!.lon.doubleValue)
        }
    }


}

