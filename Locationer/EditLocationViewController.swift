//
//  LocationDetailViewController.swift
//  Locationer
//
//  Created by CSSE Department on 7/28/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
class EditLocationViewController: UIViewController {
    var location : Location?
    var marker : GMSMarker?
    var isEditMode = false
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var tagsField: UITextField!

    @IBOutlet weak var isFavoriteSwitch: UISwitch!
    @IBAction func pressedDismissButton(sender: AnyObject) {
        var loc1 : Location
        if (isEditMode){
            loc1 = location!
            
        } else {
            loc1 = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: CoreDataUtils.managedObjectContext()) as! Location
            loc1.lat = marker!.position.latitude
            loc1.lon = marker!.position.longitude
        }
        loc1.name = nameField.text
        loc1.desc = descField.text
        loc1.isFavorite = NSNumber(bool: isFavoriteSwitch.on)

        loc1.dateAdded = NSDate()
        CoreDataUtils.saveContext()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func pressedBack(sender: AnyObject) {

        self.dismissViewControllerAnimated(true, completion: nil)
            
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if(isEditMode){
            self.nameField.text = self.location?.name
            self.descField.text = self.location?.desc
            
        }
    
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
