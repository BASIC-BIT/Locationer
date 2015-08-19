//
//  Util.swift
//  Locationer
//
//  Created by CSSE Department on 8/12/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit

class Util: NSObject {

    class func addBarToTextField(fields : [UITextField!], view : UIView!, controller : UIViewController){
        let hide = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: view, action: "endEditing:")
        let save = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: controller, action: "pressedSaveKeyboardButton")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, view.bounds.size.width, 44.0))
        toolbar.items = [save, flexSpace, hide]
        for field in fields{
            field.inputAccessoryView = toolbar
        }
    }
    class func makeViewTapableToEndEditing(vc : UIViewController){
        var tap = UITapGestureRecognizer(target: vc, action: "endEditing")
        vc.view.addGestureRecognizer(tap)
    }
    class var colorDictionary : [String : UIColor]{
        return [ "dark grey" : UIColor.darkGrayColor(), "green" : UIColor.greenColor(),"red" : UIColor.redColor(), "blue" : UIColor.blueColor(), "cyan" : UIColor.cyanColor(), "yellow" : UIColor.yellowColor(), "magenta" : UIColor.magentaColor(), "purple" : UIColor.purpleColor(), "orange" : UIColor.orangeColor()]
    }
}
