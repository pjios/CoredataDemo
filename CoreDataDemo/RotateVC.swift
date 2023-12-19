//
//  RotateVC.swift
//  CoreDataDemo
//
//  Created by Purva Joshi on 12/04/23.
//

import UIKit

class RotateVC: UIViewController {

    //MARK:- Variable Declaration
    var isRotat = false
    
    //MARK:- IBOutlet
    @IBOutlet weak var viewRotat: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.viewRotat.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        // Do any additional setup after loading the view.
    }
    
    //MARK:- IBAction
    @IBAction func onPressView(_ sender: UIButton){
//        if isRotat == true{
//            self.viewRotat.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
//            isRotat = false
//        }else{
//            self.viewRotat.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
//            isRotat = true
//
//        }
        
   
    }
}
