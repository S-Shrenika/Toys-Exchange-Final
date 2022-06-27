//
//  Toy Model.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 03/06/22.
//

import Foundation
import UIKit

struct Owner: Codable{
    var id: Int
    var email: String
    var created_at: String
}
struct Resonse: Codable{
    var toy_name: String
    var cost: Int
    var place: String
    var description: String
    var created_at: String
    var toy_id: Int
    var owner_id: Int
    var owner: Owner
}
struct ownerDetails: Codable{
    var id: Int
    var email: String
    var created_at: String
    var name: String
}
struct Request: Codable{
    var message: String
}
struct Approved: Codable{
    var approval: String
}
struct toy: Codable{
    var toy_name: String
    var cost: Int
    var place: String
    var description: String?
    var created_at: String
    var toy_id: Int
    var owner_id: Int
}
struct Req: Codable{
    var toy_id: Int
    var exchange_toy_id: Int
    var owner_id: Int
    var approval: String?
    var requested_at: String
    var ownerof_toy: Int
}
struct Resp: Codable{
    var Toy: toy
    var Request: Req
    
}

func textFld(textField: UITextField){
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0.0, y: textField.frame.height - 1, width: textField.frame.width, height: 1.0)
    bottomLine.backgroundColor = UIColor(red: 0, green: 38/255.0, blue: 119/255.0, alpha: 1.0).cgColor
    textField.borderStyle = UITextField.BorderStyle.none
    textField.layer.addSublayer(bottomLine)
}
