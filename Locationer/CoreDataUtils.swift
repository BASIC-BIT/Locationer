//
//  CoreDataUtils.swift
//  Locationer
//
//  Created by CSSE Department on 7/28/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit
import CoreData

class CoreDataUtils: NSObject {
    static var __managedObjectContext : NSManagedObjectContext?
    
    class func managedObjectContext()-> NSManagedObjectContext{
        if(__managedObjectContext==nil){
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            self.__managedObjectContext = appDelegate.managedObjectContext
        }
        return __managedObjectContext!
    }
    class func saveContext(){
        var error : NSError?
        managedObjectContext().save(&error)
        if ((CoreDataUtils.managedObjectContext() as NSManagedObjectContext).hasChanges && error != nil){
            println("There was an unresolved error : \(error?.userInfo)")
            abort()
        }
    }
}
