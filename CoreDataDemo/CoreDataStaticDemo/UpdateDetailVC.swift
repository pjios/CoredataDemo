//
//  UpdateDetailVC.swift
//  CoreDataDemo
//
//  Created by Purva Joshi on 06/04/23.
//

import UIKit
import CoreData
import SQLite3

class UpdateDetailVC: UIViewController {
    //MARK:- Variable Declaration
    //var listArraycoredata = [Users]()
    var userUpdateData = Users()
    var name = ""
    var email = ""
    var field = ""
   
    //MARK:- IBOutlet
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtUserfield: UITextField!
    @IBOutlet weak var txtUseremail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUsername.text = name
        txtUseremail.text = email
        txtUserfield.text = field
        // Do any additional setup after loading the view.
    }
    
    //MARK:- IBAction
    @IBAction func onPressUpdate(_ sender: UIButton){
        let useremail = userUpdateData.useremail ?? ""
        print(useremail)
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.childManagedObjectContext
        //let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Users")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            
        let predicate = NSPredicate(format: "useremail = '\(useremail)'")
        fetchRequest.predicate = predicate
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let objectToUpdate = result.first as? NSManagedObject {
                objectToUpdate.setValue(txtUsername.text, forKey: "username")
                objectToUpdate.setValue(txtUseremail.text, forKey: "useremail")
                objectToUpdate.setValue(txtUserfield.text, forKey: "userfield")
                appDelegate.saveContext()
//                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListVC") as? ListVC
//                self.navigationController?.pushViewController(vc!, animated: true)
                navigationController?.popViewController(animated: true)
            }
        } catch{
            print(error)
        }
        
        
        
        
    }
    
    @IBAction func onPressBack(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
