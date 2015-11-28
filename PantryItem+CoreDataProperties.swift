//
//  PantryItem+CoreDataProperties.swift
//  WhatToEat
//
//  Created by Spencer Smith on 11/25/15.
//  Copyright © 2015 Spencer Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PantryItem {

    @NSManaged var name: String?
    @NSManaged var genericName: String?
    @NSManaged var image: NSData?

}
