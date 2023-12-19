//
//  FoliosData+CoreDataClass.swift
//  
//
//  Created by Purva Joshi on 22/03/23.
//
//

import Foundation
import CoreData

public class FoliosData: NSManagedObject {
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "FoliosData", in: context)
        self.init(entity:entity!, insertInto: context)
        
    }
   
}
