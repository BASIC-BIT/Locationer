//
//  TagsTableView.swift
//  Locationer
//
//  Created by CSSE Department on 8/9/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit

class TagsTableView: UITableView {
    var editLocationViewController : EditLocationViewController!
    
    let kTagCellIdentifier = "TagCellIdentifier"
    
    var tagTypes : [Tag] {
        return editLocationViewController.tagTypes
    }
    
    func printTagCount() {
        println("tag types from inside tableView : \(tagTypes.count)")
        for tag in tagTypes{
            println("Tag with name \(tag.name) and color \(tag.color)")
        }
        self.reloadData()
    }
//    override func numberOfRowsInSection(section: Int) -> Int {
//        return tagTypes.count
//        
//    }
//    override func numberOfSections() -> Int {
//        return 1
//    }
//    override func cellForRowAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell? {
//        let cell = dequeueReusableCellWithIdentifier(kTagCellIdentifier, forIndexPath: indexPath) as! TagTypesTableViewCell
//        cell.tagNameLabel.text = tagTypes[indexPath.row].name
//        cell.tagNameLabel.textColor = Util.colorDictionary[tagTypes[indexPath.row].color]
//        return cell
//    }
    
}
