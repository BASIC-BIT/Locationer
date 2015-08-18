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



class EditLocationViewController: UIViewController , NSFetchedResultsControllerDelegate , UITextFieldDelegate , UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    let kTagCellIdentifier = "TagCellIdentifier"
    var location : Location?
    var marker : GMSMarker?
    var tagFromAddTag : Tag?
    var isEditMode = false
    var selectedTag : Tag?
    let kShowAddTagIdentifier = "ShowAddTagIdentifier"
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var tagsField: UITextField!
    @IBOutlet weak var isFavoriteSwitch: UISwitch!
    @IBOutlet weak var tagsTableView: TagsTableView!
    

    
    //MARK: - Pressed Button Methods
    @IBAction func pressedAddTag(sender: AnyObject) {
        self.performSegueWithIdentifier(kShowAddTagIdentifier, sender: self)
    }
    @IBAction func pressedRemoveTag(sender: AnyObject) {
        self.tagsTableView.setEditing(!self.tagsTableView.editing, animated: true)
    }
    @IBAction func pressedBack(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func pressedSaveKeyboardButton(){
        pressedSaveButton(self)
    }
    @IBAction func pressedSaveButton(sender: AnyObject) {
        var loc1 : Location
        if (isEditMode){
            loc1 = location!
            
        } else {
            loc1 = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: CoreDataUtils.managedObjectContext()) as! Location
            loc1.lat = marker!.position.latitude
            loc1.lon = marker!.position.longitude
            loc1.name = nameField.text
            loc1.desc = descField.text
            loc1.isFavorite = NSNumber(bool: isFavoriteSwitch.on)
            loc1.dateAdded = NSDate()
            if let tag = selectedTag {
                loc1.tag = tag
            }
        }
        
        CoreDataUtils.saveContext()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func _setSelectedTagFromLocation() {
        if let aLocation = self.location{
            self.selectedTag = aLocation.tag
            if let tag = selectedTag{
                println("let tag")
                var indexOfTagInTagTypes = -1
                for index in 0..<self.tagTypes.count{
                    if(tag.isEqual(tagTypes[index])){
                        indexOfTagInTagTypes = index
                    }
                }
                if(indexOfTagInTagTypes != -1){
                    self.tagsTableView.selectRowAtIndexPath(NSIndexPath(forRow: indexOfTagInTagTypes, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Middle)
                    self._selectRowAtIndexPath(NSIndexPath(forRow: indexOfTagInTagTypes, inSection: 0))
                    println("selected")
                } else {
                    println("couldn't find tag")
                }
            }

        }
    }
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        if(isEditMode){
            self.nameField.text = self.location?.name
            self.descField.text = self.location?.desc
            self.isFavoriteSwitch.on = self.location!.isFavorite.boolValue
            _setSelectedTagFromLocation()
        }
        //FIXME: Make  gesture delegate should recieve touch so tableview doesn't get interfered with by gesture
//        var tap = UITapGestureRecognizer(target: self, action: "endEditing")
//        tap.delegate = self
//        self.view.addGestureRecognizer(tap)
        self.nameField.becomeFirstResponder()
        self.nameField.delegate = self
        self.descField.delegate = self
        self.tagsTableView.editLocationViewController = self // don't need?
        self.tagsTableView.tag = 5


        let fields = [self.nameField, self.descField]
        Util.addBarToTextField(fields, view: self.view, controller: self)
    }
    override func viewDidAppear(animated: Bool) {
        self._tagsFetchedResultsController = nil;
        self._tagTypes = nil;
        self.tagsTableView.reloadData()
        _setSelectedTagFromLocation()
        println("objects: \(self.tagsFetchedResultsController.sections![0].objects)")
        println("num \(self.tagTypes.count)")
//        self.tagsTableView.printTagCount()

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Retrieve data from core data, fetchedresultscontroller
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
        let sortDescriptor = NSSortDescriptor(key: "isFavorite", ascending: false)
        let sortDescriptor2 = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptors = [sortDescriptor, sortDescriptor2]
        
        fetchRequest.sortDescriptors = sortDescriptors
        
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
    //MARK: - gestureRecognizer delegate functions
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if(touch.view.tag == 5){
            println("false")
            return false;
        }
        println("true")
        return true;
    }
    // MARK: - TableView Delegate and Data Source functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagTypes.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tagsTableView.dequeueReusableCellWithIdentifier(kTagCellIdentifier, forIndexPath: indexPath) as! TagTypesTableViewCell
        cell.tagNameLabel.text = tagTypes[indexPath.row].name
        cell.tagNameLabel.textColor = Util.colorDictionary[tagTypes[indexPath.row].color]
        cell.checkButton.setImage(UIImage(named: "no_check.png"), forState: UIControlState.Normal)
        cell.tag = 5
        return cell
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        println("commit")
        if editingStyle == .Delete {
            let TagToDelete = tagTypes[indexPath.row]
            self._fetchedResultsController = nil
            for aLocation in self.fetchedResultsController.sections![0].objects as! [Location]{
                if aLocation.tag == TagToDelete{
                    aLocation.tag = nil
                }
            }
            CoreDataUtils.managedObjectContext().deleteObject(TagToDelete)
            CoreDataUtils.saveContext()
            _tagsFetchedResultsController = nil;
            _tagTypes = nil;
            if tagTypes.count == 0{
                tableView.reloadData()
                setEditing(false, animated: true)
            } else {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
            self.tagsTableView.endEditing(true)
        }
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return tagTypes.count > 0
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if(self.tagsTableView.editing){
            return UITableViewCellEditingStyle.Delete
        } else {
            println("returned none")
            return UITableViewCellEditingStyle.None
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _selectRowAtIndexPath(indexPath)
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tagsTableView.cellForRowAtIndexPath(indexPath) as! TagTypesTableViewCell
        cell.checkButton.setImage(UIImage(named: "no_check.png"), forState: UIControlState.Normal)
    }
    func _selectRowAtIndexPath(indexPath : NSIndexPath){
        let cell = self.tagsTableView.cellForRowAtIndexPath(indexPath) as! TagTypesTableViewCell
        cell.checkButton.setImage(UIImage(named: "check.png"), forState: UIControlState.Normal)
        self.selectedTag = self.tagTypes[indexPath.row]
    }

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
