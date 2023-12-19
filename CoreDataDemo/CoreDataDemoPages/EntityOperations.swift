//
//  EntityOperations.swift
//  CoreDataDemo
//
//  Created by Purva Joshi on 22/03/23.

import UIKit
import CoreData


public class DataProvider {
    private let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
}

class EntityOperations: NSObject {
    
    
    static var totalRow:(_ predicate: NSPredicate?, _ context: NSManagedObjectContext, _ entityName: String) -> Int? = { predicate, context, entityName in
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        var error: NSError? = nil
        do {
            let count = try context.count(for: fetchRequest)
            return count
        }
        catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            return 0
        }
    }
    
    static func currentAppVersion() -> String{
    var appversion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    UserDefaults.standard.set(appversion, forKey: "currentAppVersion")
        return appversion
}
    
    static func currentAppBuildVersion() -> String{
        var buildnumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        UserDefaults.standard.set(buildnumber, forKey: "currentAppBuildVersion")
        return buildnumber
    }
    
    static func addClientData(modelData: [ClientGETList]) -> Void {
        let context = appDelegate.childManagedObjectContext
        EntityOperations.deleteAllData(context: context, entityName: "ClientData")
        for item in modelData {
            ClientData.add(context: context, model: item)
        }
        
        appDelegate.saveContext()
    }
    
    static func addUserData(modelData: [UsersModel]) -> Void {
        let context = appDelegate.childManagedObjectContext
        //EntityOperations.deleteAllData(context: context, entityName: "Users")
        for item in modelData {
            Users.add(context: context, model: item)
        }
        
        appDelegate.saveContext()
    }
    
    static func fetchObjectWithId(key: String, value: CVarArg, context: NSManagedObjectContext, entityName: String, isStrictMatch:Bool = false) -> NSManagedObject! {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        
        if let val = value as? Int32 {
            fetchRequest.predicate = NSPredicate(format: "%K = %d", key, val)
        }
        else{
            if isStrictMatch {
                fetchRequest.predicate = NSPredicate(format: "%K == %@", key, value)
            }
            else{
                fetchRequest.predicate = NSPredicate(format: "%K contains[c] %@", key, value)
            }
        }
        do {
            let result = try context.fetch(fetchRequest)
            if result.count > 0 {
                return result[0]
            }
            else {
                return nil
            }
        }
        catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        return nil
    }
    
    static func fetchWithPredicate(predicate: NSPredicate!, sortDescriptor descriptor:[NSSortDescriptor]!, context objContext: NSManagedObjectContext, entityName: String) -> [NSManagedObject]! {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        if descriptor != nil {
            fetchRequest.sortDescriptors = descriptor
        }
        do {
            let result = try objContext.fetch(fetchRequest)
            return result
        }
        catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        return nil
    }
    
    static func fetchWithPredicateAndLimit(predicate: NSPredicate!, sortDescriptor descriptor:[NSSortDescriptor]!, context objContext: NSManagedObjectContext, entityName: String, limit: Int?) -> [NSManagedObject]! {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        if let limit = limit {
            fetchRequest.fetchLimit = limit
        }
        if descriptor != nil {
            fetchRequest.sortDescriptors = descriptor
        }
        do {
            let result = try objContext.fetch(fetchRequest)
            return result
        }
        catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        return nil
    }
    
    static func fetchWithPredicate(predicate: NSPredicate!, sortDescriptor descriptor:[NSSortDescriptor]!, properties: [AnyObject]!, context objContext: NSManagedObjectContext, entityName: String) -> [AnyObject]! {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        if descriptor != nil {
            fetchRequest.sortDescriptors = descriptor
        }
        if properties != nil{
            fetchRequest.propertiesToFetch = properties
            fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        }
        do {
            let result = try objContext.fetch(fetchRequest)
            return result
        }
        catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        return nil
    }
    
    static func deleteAllData(context: NSManagedObjectContext, entityName: String) {
        do {
            
            if #available(iOS 9.0, *) {
                try context.persistentStoreCoordinator?.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: entityName)), with: context)
            }
            else {
                let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
                fetchRequest.returnsObjectsAsFaults = false
                let results = try context.fetch(fetchRequest)
                for managedObject in results {
                    let managedObjectData:NSManagedObject = managedObject
                    context.delete(managedObjectData)
                }
                do{
                    try context.save()
                    print("Deleted ITEMS == \(entityName)")
                }catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                    print("NON Deleted ITEMS == \(entityName)")
                }
            }
            
        }
        catch {
            print("Erroring in deleting items deleteAllData")
        }
    }
    
    static func deleteDataForEntity(entityToFetch: String, completion: @escaping(_ returned: Bool) ->()) {
        let context = appDelegate.childManagedObjectContext

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            fetchRequest.entity = NSEntityDescription.entity(forEntityName: entityToFetch, in: context)
            fetchRequest.includesPropertyValues = false
             do {
                let results = try context.fetch(fetchRequest) as! [NSManagedObject]
                for result in results {
                    context.delete(result)
                }
                try context.save()
                completion(true)
            } catch {
                completion(false)
                print("fetch error -\(error.localizedDescription)")
            }
        }
   
    static func clearAllTables() {
        //Delete Masters
        EntityOperations.deleteAllData(context: appDelegate.childManagedObjectContext, entityName: "ClientData")
        EntityOperations.deleteAllData(context: appDelegate.childManagedObjectContext, entityName: "FoliosData")
    }
    
    static func initializeData(data: NSDictionary) throws {
        clearAllTables()
       
        //ClientsAllData
        if let list = data.value(forKey: "Clients") as? NSArray {
            for item in list {
                if let obj = item as? NSDictionary {
                    let entityObj = ClientData(context: appDelegate.childManagedObjectContext)
                    if let groupId = obj.value(forKey: "GroupId") as? Int16 {
                        entityObj.groupId = groupId
                    }
                    if let name = obj.value(forKey: "Name") as? String {
                        entityObj.name = name
                    }
                    if let Code = obj.value(forKey: "Code") as? String {
                        entityObj.code = Code
                    }
                    if let UCC = obj.value(forKey: "UCC") as? String{
                        entityObj.ucc = UCC
                    }
                    if let Sequence = obj.value(forKey: "Sequence") as? Int16 {
                        entityObj.sequence = Sequence
                    }
                    if let ClientID = obj.value(forKey: "ClientID") as? String {
                        entityObj.clientID = ClientID
                    }
                    if let Email = obj.value(forKey: "Email") as? String{
                        entityObj.email = Email
                    }
                }
            }
        }
        
        //FoliosAllData
        if let list = data.value(forKey: "Folios") as? NSArray {
            for item in list {
                if let obj = item as? NSDictionary {
                    let entityObj = FoliosData(context: appDelegate.childManagedObjectContext)
                    if let groupId = obj.value(forKey: "GroupId") as? Int16 {
                        entityObj.groupId = groupId
                    }
                    if let ISIN = obj.value(forKey: "ISIN") as? String {
                        entityObj.isIN = ISIN
                    }
                    if let FolioNo = obj.value(forKey: "FolioNo") as? String {
                        entityObj.folioNo = FolioNo
                    }
                    if let UCC = obj.value(forKey: "UCC") as? String{
                        entityObj.ucc = UCC
                    }
                    if let Units = obj.value(forKey: "Units") as? Double{
                        entityObj.units = Units
                    }
                   // entityObj.bindWithDict(dict: obj,reportType: "ACTIVEBUTNOTONLINE")
                }
            }
        }
        
//        //
//        if let list = data.value(forKey: "UserData") as? NSArray {
//            for item in list {
//                if let obj = item as? NSDictionary {
//                    let entityObj = Users(context: appDelegate.childManagedObjectContext)
//                    if let userfield = obj.value(forKey: "userfield") as? String {
//                        entityObj.userfield = userfield
//                    }
//                    if let username = obj.value(forKey: "username") as? String {
//                        entityObj.username = username
//                    }
//                    if let useremail = obj.value(forKey: "useremail") as? String{
//                        entityObj.useremail = useremail
//                    }
//
//                   // entityObj.bindWithDict(dict: obj,reportType: "ACTIVEBUTNOTONLINE")
//                }
//            }
//        }
        
        do{
            try appDelegate.childManagedObjectContext.save()
        }catch {
            print("ERROR IN SAVING InitialiseData")
        }
       
        print("InitialiseData method is completed...")
    }
    
    static func fetchWithPredicate(predicate: NSPredicate!, sortDescriptor descriptor:[NSSortDescriptor]!, context objContext: NSManagedObjectContext, entityName: String, limit: Int?) -> [NSManagedObject]! {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        if descriptor != nil {
            fetchRequest.sortDescriptors = descriptor
        }
        if let limit = limit {
            fetchRequest.fetchLimit = limit
        }
        do {
            let result = try objContext.fetch(fetchRequest)
            return result
        }
        catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        return nil
    }
    
   
    static func updateData(dictData: NSDictionary) {
        
//        if let listTransaction = dictData.value(forKey: "Transactions") as? [NSDictionary] {
//            for item in listTransaction {
//                if let id = item.value(forKey: "TransactionId") as? Int32 {
//                    var objTrans: Transactions!
//                    if let obj = EntityOperations.fetchObjectWithId(key: "id", value: id, context: appDelegate.childManagedObjectContext, entityName: "Transactions") as? Transactions {
//                        objTrans = obj
//                    }
//                    else {
//                        objTrans = Transactions(context: appDelegate.childManagedObjectContext)
//                    }
//                    objTrans.bindWithDict(dict: item)
//                }
//            }
//        }
//
//
//        if let list = dictData.value(forKey: "ACTIVEBUTNOTONLINE") as? NSArray {
//            for item in list {
//                var entityObj = MFClientReport(context: appDelegate.childManagedObjectContext)
//                if let obj = item as? NSDictionary {
//                    if let clientID = obj.value(forKey: "ClientID") as? Int, let entity = EntityOperations.fetchObjectWithId(key: "clientId", value: Int32(clientID), context: appDelegate.childManagedObjectContext, entityName: "MFClientReport") as? MFClientReport {
//                        //removeNotification(UUID: entity.taskId)
//                        entityObj = entity
//                    }
//                    else {
//                        entityObj = MFClientReport(context: appDelegate.childManagedObjectContext)
//                    }
//                    entityObj.bindWithDict(dict: obj,reportType: "ACTIVEBUTNOTONLINE")
//                }
//            }
//        }
        appDelegate.saveContext()
        
    }
}
