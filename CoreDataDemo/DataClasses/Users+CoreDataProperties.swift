//
//  Users+CoreDataProperties.swift
//  
//
//  Created by Purva Joshi on 06/04/23.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var userfield: String?
    @NSManaged public var username: String?
    @NSManaged public var useremail: String?

}
