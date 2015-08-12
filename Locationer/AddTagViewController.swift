//
//  AddTagViewController.swift
//  Locationer
//
//  Created by CSSE Department on 8/11/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit
import CoreData
//TODO: Make this vc prettier. It's bare bones.
class AddTagViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource{
    var tagTypes : [Tag]? = nil
    var colorNames : [String] = []
    var colorDictionary : [String : UIColor] = [:]
    var colors : [UIColor] = [UIColor.blackColor(),UIColor.darkGrayColor(),UIColor.lightGrayColor(),UIColor.whiteColor(),UIColor.grayColor(),UIColor.redColor()]
    var selectedColor : String?


    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var tagNameTextField: UITextField!
    @IBAction func pressedSaveTag(sender: UIButton) {
        let tagName = self.tagNameTextField.text
        let newTag = NSEntityDescription.insertNewObjectForEntityForName("Tag", inManagedObjectContext: CoreDataUtils.managedObjectContext()) as! Tag
        newTag.name = tagName
        newTag.color = colorNames[self.colorPicker.selectedRowInComponent(0)]
        newTag.lastTouchDate = NSDate()
        CoreDataUtils.saveContext()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pressedClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.colorPicker.delegate = self
        self.colorPicker.dataSource = self
        // populate this dictionary with all the colors that you want to populate the picker
        self.colorDictionary = Util.colorDictionary
        
        for (name, color) in colorDictionary{
            println(name)
            colorNames.append(name)
        }
        
        let fields = [self.tagNameTextField]
        Util.addBarToTextField(fields, view: self.view)
        Util.makeViewTapableToEndEditing(self)



        // Do any additional setup after loading the view.
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let colorLookup = colorDictionary[colorNames[row]]
        let name = colorNames[row]
        var string : NSAttributedString
        if let color = colorLookup {
            string = NSAttributedString(string: name, attributes: [NSForegroundColorAttributeName:color])
        } else {
            string = NSAttributedString(string: name)
        }

        return string
        
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("selected row")
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colorNames.count
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
