//
//  ListVC.swift
//  CoreDataDemo
//
//  Created by Purva Joshi on 06/04/23.
//

import UIKit

class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    //MARK:- Variable Declaration
    var arrayOfList = [Users]()

    //MARK:- IBOutlet
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblDatanotFound: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.lblDatanotFound.isHidden = true
        self.fetchData()
        self.tblView.reloadData()
    }
    
    //MARK;- UItableview Datasourse and Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listcell", for: indexPath) as! staticDataList
        let data = arrayOfList[indexPath.row]
        cell.lblName.text = "Name: \(data.username ?? "")"
        cell.lblEmail.text = "Email: \(data.useremail ?? "")"
        cell.lblFlield.text = "Branch: \(data.userfield ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = arrayOfList[indexPath.row]
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateDetailVC") as? UpdateDetailVC
        vc?.name = data.username ?? ""
        vc?.email = data.useremail ?? ""
        vc?.field = data.userfield ?? ""
        vc?.userUpdateData = data
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            var refreshAlert = UIAlertController(title: "DemoCoreData", message: "Are You Sure you want to delete this item? ", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
              //  self.navigationController?.popToRootViewController(animated: true)
                let context = appDelegate.childManagedObjectContext
                 let index = indexPath.row
                context.delete(self.arrayOfList[index])
                self.arrayOfList.remove(at: index)
                 do {
                     appDelegate.saveContext()
                     print("Deleted")
                     //self.setData()
                  
                 } catch {
                     print ("There was an error")
                 }
                 self.tblView.deleteRows(at: [indexPath], with: .automatic)
                 self.tblView.reloadData()
                
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in

                refreshAlert .dismiss(animated: true, completion: nil)
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
       }

    
    //fetch the data
      func fetchData(){
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          let context = appDelegate.childManagedObjectContext
          do{
              arrayOfList = try context.fetch(Users.fetchRequest())
          }
              //if error exists/catch it
          catch{
              print(error)
          }
          if arrayOfList.count > 0 {
              self.lblDatanotFound.isHidden = true
          }else{
              self.lblDatanotFound.isHidden = false
          }
      }

    //MARK:- IBAction
    @IBAction func onPressBack(_ sender: UIButton){
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is LoginVC {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
        //self.navigationController?.popViewController(animated: true)
    }

   
}

class staticDataList: UITableViewCell{
    
    //MARK:- IBOutlet
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblFlield: UILabel!
    
}
