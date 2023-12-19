//
//  LoginVC.swift
//  CoreDataDemo
//
//  Created by Purva Joshi on 29/03/23.
//

import UIKit
import CoreData

class LoginVC: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtUserfield: UITextField!
    @IBOutlet weak var txtUseremail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var appversion = EntityOperations.currentAppVersion()
        UserDefaults.standard.set(appversion, forKey: "currentAppVersion")
        var buildnumber = EntityOperations.currentAppBuildVersion()
        UserDefaults.standard.set(buildnumber, forKey: "currentAppBuildVersion")
        print("Login Screen v \(appversion) build \(buildnumber)")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setup()
    }
    
    func setup(){
        txtUsername.text = ""
        txtUseremail.text = ""
        txtUserfield.text = ""
        txtUserfield.resignFirstResponder()
        txtUseremail.resignFirstResponder()
        
    }
    
    //MARK:- IBAction
    @IBAction func onPressSubmit(_ sender: UIButton){
        if txtUsername.text == "" && txtUseremail.text == "" && txtUserfield.text == ""{
            let alertController = UIAlertController(title: "CoreDataDemo", message: "Please fill the all details", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                // Code in this block will trigger when OK button is tapped.
                print("Ok button tapped");
                
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }else{
            var userdata = UsersModel()
            userdata.useremail = txtUseremail.text
            userdata.username = txtUsername.text
            userdata.userEfield = txtUserfield.text
            EntityOperations.addUserData(modelData: [userdata])
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListVC") as? ListVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
    
    @IBAction func onPressUserList(_ sender: UIButton){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListVC") as? ListVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
