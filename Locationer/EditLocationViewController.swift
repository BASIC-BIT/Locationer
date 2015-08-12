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


class EditLocationViewController: UIViewController , NSFetchedResultsControllerDelegate , UITextFieldDelegate {
    var location : Location?
    var marker : GMSMarker?
    var isEditMode = false
    let kShowAddTagIdentifier = "ShowAddTagIdentifier"
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var tagsField: UITextField!

    @IBOutlet weak var tagsTableView: TagsTableView!
    @IBAction func pressedAddTag(sender: AnyObject) {
        self.performSegueWithIdentifier(kShowAddTagIdentifier, sender: self)
    }
    @IBAction func pressedRemoveTag(sender: AnyObject) {
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
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
            self.isFavoriteSwitch.on = self.location!.isFavorite.boolValue
        }
        
        
        var tap = UITapGestureRecognizer(target: self, action: "endEditing")
        self.view.addGestureRecognizer(tap)
        self.nameField.becomeFirstResponder()
        self.nameField.delegate = self
        self.descField.delegate = self
        self.tagsTableView.editLocationViewController = self
        let fields = [self.nameField, self.descField]
        Util.addBarToTextField(fields, view: self.view)


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var tagTypes: [Tag] {
        if(_tagTypes != nil){
            return _tagTypes!
        }
        
        let tags = self.tagsFetchedResultsController.sections![0].objects as! [Tag]
        
        _tagTypes = tags
        
        return _tagTypes!
        
    }
    var _tagTypes: [Tag]? = nil
    
    var tagsFetchedResultsController: NSFetchedResultsController {
        if _tagsFetchedResultsController != nil {
            return _tagsFetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Tag", inManagedObjectContext: CoreDataUtils.managedObjectContext())
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "lastTouchDate", ascending: false)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataUtils.managedObjectContext(), sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _tagsFetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        if !_tagsFetchedResultsController!.performFetch(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _tagsFetchedResultsController!
    }
    
    var _tagsFetchedResultsController: NSFetchedResultsController? = nil
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == kShowAddTagIdentifier){
            let addTagVC = segue.destinationViewController as! AddTagViewController
            addTagVC.tagTypes = self.tagTypes
        }
    }


}
