//
//  FoliosData+CoreDataProperties.swift
//  
//
//  Created by Purva Joshi on 22/03/23.
//
//

import Foundation
import CoreData


extension FoliosData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoliosData> {
        return NSFetchRequest<FoliosData>(entityName: "FoliosData")
    }

    @NSManaged public var groupId: Int16
    @NSManaged public var ucc: String?
    @NSManaged public var isIN: String?
    @NSManaged public var folioNo: String?
    @NSManaged public var units: Double

    
}
