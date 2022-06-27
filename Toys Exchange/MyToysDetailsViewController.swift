//
//  MyToysDetailsViewController.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 06/06/22.
//

import UIKit

class MyToysDetailsViewController: UIViewController, UITextFieldDelegate {
    var activeTextField:UITextField!
    var toyid: Int!
    var editTextFieldToggle: Bool = false
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var dateAdded: UITextField!
    @IBOutlet weak var place: UITextField!
    @IBOutlet weak var toyName: UITextField!
    @IBOutlet weak var cost: UITextField!
    @IBOutlet weak var toyImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        makegetreq()
//        textFld(textField: toyName)
//        textFld(textField: cost)
//        textFld(textField: place)
//        textFld(textField: desc)
//        textFld(textField: dateAdded)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismisskeyboard))
        self.view.addGestureRecognizer(tap)
        self.navigationController?.navigationBar.updateNavigationBarColor()
        self.navigationController?.navigationBar.tintColor = .white
    }
    @objc func dismisskeyboard(){
        self.view.endEditing(true)
    }
    func makegetreq(){
        guard let url = URL(string: "http://127.0.0.1:8000/toys/\(toyid!)") else{
            print("Error")
            return
        }
        getreq(url: url) { arraydata, error in
            DispatchQueue.main.async {
                self.toyName.text = arraydata!.toy_name
                self.toyName.isUserInteractionEnabled = false
                self.cost.text = "\(String(describing: arraydata!.cost))"
                self.cost.isUserInteractionEnabled = false
                self.place.text = arraydata!.place
                self.place.isUserInteractionEnabled = false
                self.desc.text = arraydata!.description
                self.desc.isUserInteractionEnabled = false
                let created = arraydata!.created_at
                self.dateAdded.text = "\(created.dropLast(16))"
                self.dateAdded.isUserInteractionEnabled = false
            }
        }
    }
    func getreq(url: URL,completion:@escaping (Resonse?, Error?) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)", forHTTPHeaderField: "Authorization")
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data{
                let result = try? JSONDecoder().decode(Resonse.self, from: data)
                if result != nil{
                    completion(result,nil)
                }
                else{
                    completion(nil, error)
                }
            }
            else{
                completion(nil,error)
            }
    }.resume()
    }
    func makeputreq(){
        guard let url = URL(string: "http://127.0.0.1:8000/toys/\(toyid!)") else{
            print("Error")
            return
        }
        putreq(url: url) { arraydata, error in
            DispatchQueue.main.async {
                self.toyName.text = arraydata!.toy_name
                self.toyName.isUserInteractionEnabled = false
                self.cost.text = "\(String(describing: arraydata!.cost))"
                self.cost.isUserInteractionEnabled = false
                self.place.text = arraydata!.place
                self.place.isUserInteractionEnabled = false
                self.desc.text = arraydata!.description
                self.desc.isUserInteractionEnabled = false
                let created = arraydata!.created_at
                self.dateAdded.text = "\(created.dropLast(16))"
                self.dateAdded.isUserInteractionEnabled = false
            }
        }
    }
    func putreq(url: URL, completion:@escaping (Resonse?, Error?)->Void){
        let info: [String:String?] = [
            "toy_name":toyName.text! ,
            "cost":cost.text!,
            "place":place.text!,
            "description":desc.text
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: info, options: .fragmentsAllowed)
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data{
                let result = try? JSONDecoder().decode(Resonse.self, from: data)

                if result != nil{
                    completion(result,nil)
                }
                else{
                    completion(nil, error)
                }
            }
            else{
                completion(nil,error)
            }
        }.resume()
    }
    @IBAction func editClicked(_ sender: UIButton) {
        editTextFieldToggle = !editTextFieldToggle
            if editTextFieldToggle == true {
                editBtn.setTitle("Done", for: .normal)
                textFieldActive()
            } else {
                textFieldDeactive()
                editBtn.setTitle("Edit", for: .normal)
                makeputreq()
            }
    }
    func textFieldActive(){
        self.toyName.isUserInteractionEnabled = true
        self.cost.isUserInteractionEnabled = true
        self.desc.isUserInteractionEnabled = true
        self.place.isUserInteractionEnabled = true
        self.dateAdded.isUserInteractionEnabled = false
    }
    func textFieldDeactive(){
        self.toyName.isUserInteractionEnabled = false
        self.cost.isUserInteractionEnabled = false
        self.desc.isUserInteractionEnabled = false
        self.place.isUserInteractionEnabled = false
        self.dateAdded.isUserInteractionEnabled = false
    }
}
