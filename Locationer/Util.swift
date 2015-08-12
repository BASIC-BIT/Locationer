//
//  Util.swift
//  Locationer
//
//  Created by CSSE Department on 8/12/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit

class Util: NSObject {

    class func addBarToTextField(fields : [UITextField!], view : UIView!){
        let hide = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: view, action: "endEditing:")

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, view.bounds.size.width, 44.0))
        toolbar.items = [flexSpace, hide]
        for field in fields{
            field.inputAccessoryView = toolbar
        }
    }
}
