//
//  TagsTableView.swift
//  Locationer
//
//  Created by CSSE Department on 8/9/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit

class TagsTableView: UITableView {
    var  editLocationViewController : EditLocationViewController!
    
    let kTagCellIdentifier = "TagCellIdentifier"
    
    var tagTypes : [Tag] {
        return editLocationViewController.tagTypes
    }
    
    override func numberOfRowsInSection(section: Int) -> Int {
        return editLocationViewController.tagTypes.count

    }
    
    override func numberOfSections() -> Int {
        return 1
    }
    override func cellForRowAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell? {
        let cell = dequeueReusableCellWithIdentifier(kTagCellIdentifier, forIndexPath: indexPath) as! LocationTableViewCell
        cell.textLabel!.text = tagTypes[indexPath.row].name
        cell.textLabel!.textColor = Util.colorDictionary[tagTypes[indexPath.row].color]
        return cell
    }
    
}
