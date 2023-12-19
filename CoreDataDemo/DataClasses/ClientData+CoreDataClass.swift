//
//  ClientData+CoreDataClass.swift
//  
//
//  Created by Purva Joshi on 22/03/23.
//
//

import Foundation
import CoreData


public class ClientData: NSManagedObject {
    
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "ClientData", in: context)
        self.init(entity:entity!, insertInto: context)
    }
    
    static func add(context: NSManagedObjectContext, model: ClientGETList) {
    
        var entity = ClientData(context: context)
      
        if let name = model.name {
            entity.name = name
        } else {
            entity.name = ""
        }
        
        if let code = model.code {
            entity.code = code
        } else {
            entity.code = ""
        }
        
        if let ucc = model.ucc {
            entity.ucc = ucc
        } else {
            entity.ucc = ""
        }
        if let clientID = model.clientID {
            entity.clientID = clientID
        } else {
            entity.clientID = ""
        }
        if let email = model.email {
            entity.email = email
        } else {
            entity.email = ""
        }
        if let groupID = model.groupID {
            entity.groupId = groupID
        } else {
            entity.groupId = 0
        }
        if let sequence = model.sequence {
            entity.sequence = sequence
        } else {
            entity.sequence = 0
        }
    }
}
