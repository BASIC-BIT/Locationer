//
//  LocationTableViewCell.swift
//  Locationer
//
//  Created by CSSE Department on 8/9/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var starredButton: UIButton!

    
    var location : Location!
    
    func configureCellForLocation( location : Location){
        self.location = location
        self.nameLabel.text = self.location.name
        if let tag = self.location?.tag {
            self.tagLabel.text = tag.name
        }else{
            self.tagLabel.text = ""
        }
        
        self.starredButton.setTitle(self.location.isFavorite.boolValue ? "Favorite" : "Not Favorite", forState: UIControlState.Normal)
//        self.starredButton.setImage(, forState: UIControlState.)
    }
    @IBAction func pressedStarButton(sender: AnyObject) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
