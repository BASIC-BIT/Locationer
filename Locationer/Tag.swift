//
//  Tag.swift
//  Locationer
//
//  Created by CSSE Department on 8/9/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import Foundation
import CoreData

class Tag: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var color: String
    @NSManaged var lastTouchDate: NSDate
    @NSManaged var location: Location

}
