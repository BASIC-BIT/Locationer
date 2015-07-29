//
//  LocationDetailViewController.swift
//  Locationer
//
//  Created by CSSE Department on 7/21/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit

class LocationDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var descLabel : UILabel!
    @IBOutlet weak var isFavLabel: UILabel!
    var location : Location?


    func configureView() {
        // Update the user interface for the detail item.
            if let nl = self.nameLabel {
                nl.text = location!.name
            }
            if let dl = self.descLabel {
                dl.text = location!.desc
            }
        if let fl = self.isFavLabel {
            fl.text = location?.isFavorite.boolValue.description
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

