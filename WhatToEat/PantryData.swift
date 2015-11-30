//
//  PantryData.swift
//  WhatToEat
//
//  This is also a singleton class that takes care of all of the getting and inserting
//      of items into the PantryData entity.
//
//  Created by Spencer Smith on 11/28/15.
//  Copyright © 2015 Spencer Smith. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PantryData {
    static let sharedInstance = PantryData()
    var theUIImage = UIImage(named: "emptyBox.jpg")
    
    //Will insert a new pantry item into the pantry.  If the item is inserted it will
    //  return true, if the item has already been inserted it will return false.
    func insertPantryItem(name: String, image: NSData?) -> Bool
    {
        if !pantryItemAlreadyInserted(name)
        {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
        
            let theNewItem = NSEntityDescription.insertNewObjectForEntityForName("PantryItem", inManagedObjectContext: managedContext) as! PantryItem
            theNewItem.name = name
            if let imageData = image
            {
                theNewItem.image = imageData
            } else {
                theNewItem.image = UIImageJPEGRepresentation(theUIImage!, 100)
            }
            
            do
            {
                try managedContext.save()
            } catch let error as NSError {
                print(error)
            }
            return true
        } else {
            return false
        }
    }
    
    
    func getPantryItems() -> NSArray?
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "PantryItem")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            return results as! [NSManagedObject]
        } catch let error as NSError {
            print(error)
        }
        
        return nil
    }
    
    //This function is used to check each item before insertion to assert that no
    //      duplicate items have been entered.
    func pantryItemAlreadyInserted(itemName: String) -> Bool
    {
        let pantryItems = getPantryItems()
        for item in pantryItems!
        {
            if item.name == itemName
            {
                return true;
            }
        }
        return false
    }
    
}