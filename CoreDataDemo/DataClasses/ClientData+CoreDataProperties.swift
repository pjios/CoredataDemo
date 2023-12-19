//
//  ClientData+CoreDataProperties.swift
//  
//
//  Created by Purva Joshi on 22/03/23.
//
//

import Foundation
import CoreData


extension ClientData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClientData> {
        return NSFetchRequest<ClientData>(entityName: "ClientData")
    }

    @NSManaged public var name: String?
    @NSManaged public var code: String?
    @NSManaged public var ucc: String?
    @NSManaged public var groupId: Int16
    @NSManaged public var sequence: Int16
    @NSManaged public var clientID: String?
    @NSManaged public var email: String?

}
