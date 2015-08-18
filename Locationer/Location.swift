//
//  Location.swift
//  Locationer
//
//  Created by CSSE Department on 8/18/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import Foundation
import CoreData

class Location: NSManagedObject {

    @NSManaged var dateAdded: NSDate
    @NSManaged var desc: String
    @NSManaged var isFavorite: NSNumber
    @NSManaged var lat: NSNumber
    @NSManaged var lon: NSNumber
    @NSManaged var name: String
    @NSManaged var address: String?
    @NSManaged var tag: Tag?

}
