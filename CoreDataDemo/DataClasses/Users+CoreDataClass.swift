//
//  Users+CoreDataClass.swift
//  
//
//  Created by Purva Joshi on 06/04/23.
//
//

import Foundation
import CoreData

@objc(Users)
public class Users: NSManagedObject {
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
        self.init(entity: entity!, insertInto: context)
    }
    
    static func add(context: NSManagedObjectContext, model: UsersModel){
        var entity = Users(context: context)
        
        if let username = model.username{
            entity.username = username
        } else{
            entity.username = ""
        }
        
        if let userfield = model.userEfield{
            entity.userfield = userfield
        } else{
            entity.userfield = ""
        }
        
        if let useremail = model.useremail{
            entity.useremail = useremail
        } else{
            entity.useremail = ""
        }
        
    }
}
