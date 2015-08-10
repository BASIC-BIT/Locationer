//
//  TagsTableView.swift
//  Locationer
//
//  Created by CSSE Department on 8/9/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit

class TagsTableView: UITableView {
    var  editLocationViewController : EditLocationViewController?
    
    let kTagCellIdentifier = "TagCellIdentifier"
    
    
    
    
    override func numberOfRowsInSection(section: Int) -> Int {
//        return editLocationViewController!.tagTypes.count
        return 1
    }
    
    override func numberOfSections() -> Int {
        return 1
    }
    override func cellForRowAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell? {
        let cell = dequeueReusableCellWithIdentifier(kTagCellIdentifier, forIndexPath: indexPath) as! LocationTableViewCell
        cell.textLabel!.text = "Tag Example"
        cell.textLabel!.textColor = UIColor.blueColor()
        return cell
    }
}
