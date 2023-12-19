//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Purva Joshi on 22/03/23.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WebServiceHelperDelegate , UISearchBarDelegate{
   
    //MARK:- Variable Declaration
    var listArraycoredata = [ClientData]()
    var allgetData = [ClientAllData]()
    
    var ISIN : String = "7T+lYrv35ESPCryuFTympg=="
    var IsForTrading : String = "uWMWUP8s8rAOCYtsBYBkGQ=="
    var IsUnitsRequired = "fxeOrGH+sPuI5QUAfTGzmw=="
    var Search = "5Hm/mfB50uD9RVYi/hy4pw=="
    var UserID = "hS27dutig01K2Vw2X9RKQw=="
    var TokenID = "myl6PTScKH1bXC5gzZYcUJmIdT6sDDjM0xvWUj9FUe4XrmrYWjguuiRfBpS5HnxZFuhE6bxTyS86dNMHgBhuB2xxV8O7Q5rY9VAEe9LWFTWkv7hfbuHIq5S89GCF3lphlTbS3Xr9/IAgnYRzudn2zsNxQdvyYZRSgEt+lwimDyiWQfkTEJYzyEQBzPnmp0eBfw9ABZXmOU5miTYYf15Jo9CgXLrj4VmQOHe/JPXUyRM="
    var listFilteredData = [ClientData]()
    var isSearch = false
    
    //MARK:- IBOutlet
    @IBOutlet weak var tblview: UITableView!
    @IBOutlet weak var searchData: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
        searchData.delegate = self
        for users in 0..<listArraycoredata.count{
            print(listArraycoredata[users].name ?? "")
        }
        
        // Do any additional setup after loading the view.
    }

    func setData(){
        self.listArraycoredata = EntityOperations.fetchWithPredicate(predicate: nil, sortDescriptor: nil, context: appDelegate.childManagedObjectContext, entityName: "ClientData",limit: nil)  as! [ClientData]
        if listArraycoredata.count == 0{
            getClientAllDataAPI()
        }else{
            self.tblview.reloadData()
        }
        print(listArraycoredata)
    }
    //MARK:- UITableview Datasourse and Delegate Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch == true {
            return listFilteredData.count
        }else{
            return listArraycoredata.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListCell
        if isSearch == true{
            let dict = listFilteredData[indexPath.row]
            cell.lblName.text = dict.name
            cell.lblEmail.text = dict.clientID
        }else{
            let dict = listArraycoredata[indexPath.row]
            cell.lblName.text = dict.name
            cell.lblEmail.text = dict.clientID
        }
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            
            var refreshAlert = UIAlertController(title: "DemoCoreData", message: "Are You Sure you want to delete this item? ", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.navigationController?.popToRootViewController(animated: true)
                let context = appDelegate.childManagedObjectContext
                 let index = indexPath.row
                context.delete(self.listArraycoredata[index])
                self.listArraycoredata.remove(at: index)
                 do {
                     try appDelegate.saveContext()
                     print("Deleted")
                     //self.setData()
                  
                 } catch {
                     print ("There was an error")
                 }
                self.listFilteredData = self.listArraycoredata
                 self.tblview.deleteRows(at: [indexPath], with: .automatic)
                 self.tblview.reloadData()
                
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in

                refreshAlert .dismiss(animated: true, completion: nil)
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func getClientAllDataAPI(){
        let parameters = NSMutableDictionary()
        parameters.setValue(ISIN, forKey: "ISIN")
        parameters.setValue(IsForTrading, forKey: "IsForTrading")
        parameters.setValue(IsUnitsRequired, forKey: "IsUnitsRequired")
        parameters.setValue(Search, forKey: "Search")
        parameters.setValue(UserID, forKey: "UserID")
        parameters.setValue(TokenID, forKey: "TokenID")
        print(parameters)
        let apicallclass = WebServiceHelper()
        apicallclass.webService_POST(url: "https://dfsmobile.jmfonline.in/api/MFOnline/GetClients", parameters: parameters, withIdentifier: "", delegate: self)
    }
    
    func response_success(responseData: Data, ForIdentifier identifier: String) {
        do{
           let jsonDecoderData = try JSONDecoder().decode(ClientDataModel.self, from: responseData)
            let jsonObj = try JSONSerialization.jsonObject(with: responseData as Data, options: []) as! NSDictionary
            print("Login Json Object : \(jsonObj)")
                if jsonObj.value(forKey: "status") as? String ?? ""  == "S"{
                let data = jsonObj.value(forKey: "data") as! NSDictionary
                
                let listClient = data.value(forKey: "Clients") as! [NSDictionary]
                let listFolio = data.value(forKey: "Folios") as! [NSDictionary]
                print(listClient)
                print(listFolio)
                DispatchQueue.main.async {
                    EntityOperations.addClientData(modelData: jsonDecoderData.data.clients!)
                    self.listArraycoredata = EntityOperations.fetchWithPredicate(predicate: nil, sortDescriptor: nil, context: appDelegate.childManagedObjectContext, entityName: "ClientData",limit: nil)  as! [ClientData]
                    self.tblview.reloadData()
                }
            }
            
        }catch{
            
        }
    }
    
    //MARK:- Searchbar delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      isSearch = false
        searchData.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        listFilteredData.removeAll()
        if let text = searchBar.text, text.count > 0 {
            
            let searchText = text.lowercased()
            isSearch = true
            listFilteredData = listArraycoredata.filter({ (obj) -> Bool in
                return (obj.name?.lowercased() ?? "").contains(searchText)
            })
        }
        else
        {
            listFilteredData = listArraycoredata
            isSearch = false
        }
        self.tblview.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearch = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchData.text = ""
        self.searchData.endEditing(true)
        searchBar.resignFirstResponder()
        self.tblview.reloadData()
    }
    func response_fail(errorType: Webservice_Error, error: NSError!, ForIdentifier identifier: String) {
        print("Error")
    }
}

class ListCell: UITableViewCell{
    
    //MARK:- IBOutlet
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblgender: UILabel!
}

