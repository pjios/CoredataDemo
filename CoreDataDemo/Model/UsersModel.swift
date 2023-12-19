//
//  UsersModel.swift
//  CoreDataDemo
//
//  Created by Purva Joshi on 29/03/23.
//

import Foundation

class UsersModel: Codable{
    var username: String?
    var userEfield: String?
    var useremail: String?
    
    enum CodingKeys: String, CodingKey{
        case username = "username"
        case userEfield = "userEfield"
        case useremail = "useremail"
    }
}
