//
//  ApproveDetailViewController.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 14/06/22.
//

import UIKit

class ApproveDetailViewController: UIViewController {
    var toyData: Resp!
    var toyid: Int!
    var ownerid: Int!
    var option: String!
    @IBOutlet weak var innerview: UIView!
    @IBOutlet weak var apprveBtn: UIButton!
    @IBOutlet weak var approveLbl: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var myToyPlace: UILabel!
    @IBOutlet weak var myToyCost: UILabel!
    @IBOutlet weak var myToyName: UILabel!
    @IBOutlet weak var ownerEmail: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var toyName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        innerview.backgroundColor = UIColor(red: 0, green: 38/255.0, blue: 119/255.0, alpha: 1.0).withAlphaComponent(0.50)
        innerview.isOpaque = false
        innerview.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        innerview.layer.shadowOpacity = 1.0
        innerview.layer.masksToBounds = false
        innerview.layer.cornerRadius = 20.0
        innerview.layer.shadowColor = UIColor.gray.cgColor
        myToyCost.textColor = .white
        myToyName.textColor = .white
        myToyPlace.textColor = .white
        //let req = toyData.Request.requested_at
        toyid = toyData.Request.exchange_toy_id
        ownerid = toyData.Request.owner_id
        myToyName.text = toyData.Toy.toy_name
        myToyCost.text = "\(toyData.Toy.created_at.dropLast(16))"
        myToyPlace.text = toyData.Toy.place
        makegetreq()
        makegetreq1()
        makegetreq2()
        self.navigationController?.navigationBar.updateNavigationBarColor()
        self.navigationController?.navigationBar.tintColor = .white
    }
    func makegetreq(){
        let toy = self.toyid
        guard let url = URL(string: "http://127.0.0.1:8000/toys/\(toy!)") else{
            print("Error")
            return
        }
        getreq(url: url) { arraydata, error in
            DispatchQueue.main.async {
                self.toyName.text = arraydata?.toy_name
                self.place.text = arraydata?.place
                self.cost.text = "\(arraydata!.cost)"
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
    func makegetreq1(){
        let id = self.ownerid
        guard let url = URL(string: "http://127.0.0.1:8000/user/\(id!)") else{
            print("Error")
            return
        }
        getreq1(url: url) { arraydata, error in
            DispatchQueue.main.async {
                self.ownerName.text = arraydata!.name
                self.ownerEmail.text = arraydata!.email
            }
        }
    }
    func getreq1(url: URL,completion:@escaping (ownerDetails?, Error?) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data{
                let result = try? JSONDecoder().decode(ownerDetails.self, from: data)
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
    func makegetreq2(){
        let id = toyData.Request.owner_id
        let id1 = toyData.Toy.toy_id
        guard let url = URL(string: "http://127.0.0.1:8000/approved/\(id)/\(id1)") else{
            print("Error")
            return
        }
        getreq2(url: url) { arraydata, error in
            DispatchQueue.main.async {
                if arraydata?.approval == "yes" {
                    self.apprveBtn.alpha = 0
                    self.approveLbl.text = "✅ Request Approved"
                    self.approveLbl.textColor = UIColor(red: 0, green: 38/255.0, blue: 119/255.0, alpha: 1.0)
                    self.approveLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)

                }
                else if arraydata?.approval == "no"{
                    self.apprveBtn.alpha = 0
                    self.approveLbl.text = "❌ Request Rejected"
                    self.approveLbl.textColor = .white
//                    self.approveLbl.backgroundColor = UIColor(red: 0, green: 38/255.0, blue: 119/255.0, alpha: 1.0)
                    self.approveLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
                }
                else{
                    self.approveLbl.alpha = 0
                }
            }
        }
    }
    func getreq2(url: URL,completion:@escaping (Approved?, Error?) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)", forHTTPHeaderField: "Authorization")
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data{
                let result = try? JSONDecoder().decode(Approved.self, from: data)
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
    func putreq( opt:String, url: URL, completion:@escaping (Req?, Error?)->Void){
        let info: [String:Any] = [
            "toy_id": toyData.Toy.toy_id,
            "exchange_toy_id":toyData.Request.exchange_toy_id ,
            "ownerof_toy": toyData.Request.ownerof_toy,
            "approval": opt
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: info, options: .fragmentsAllowed)
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data{
                let result = try? JSONDecoder().decode(Req.self, from: data)

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
    func clickedNo(){
        let id = toyData.Request.owner_id
        let id1 = toyData.Toy.toy_id
//        print(id,id1)
        guard let url = URL(string: "http://127.0.0.1:8000/approve/\(id)/\(id1)") else{
            print("Error")
            return
        }
        let str = "no"
        putreq(opt: str, url: url) { arraydata, error in
            DispatchQueue.main.async {
                print("done")
                self.approveLbl.alpha = 1
                self.approveLbl.text = "❌ Request Rejected"
                self.approveLbl.textColor = UIColor(red: 0, green: 38/255.0, blue: 119/255.0, alpha: 1.0)
                self.apprveBtn.alpha = 0
                self.approveLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
            }
        }
    }
    func clickedYes(){
        let id = toyData.Request.owner_id
        let id1 = toyData.Toy.toy_id
//        print(id,id1)
        guard let url = URL(string: "http://127.0.0.1:8000/approve/\(id)/\(id1)") else{
            print("Error")
            return
        }
        let str = "yes"
        putreq(opt: str, url: url) { arraydata, error in
            DispatchQueue.main.async {
                print("done")
                self.approveLbl.alpha = 1
                self.approveLbl.textColor = UIColor(red: 0, green: 38/255.0, blue: 119/255.0, alpha: 1.0)
                self.approveLbl.text = "✅ Request Approved"
                self.apprveBtn.alpha = 0
                self.approveLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
            }
        }
    }
    @IBAction func approvalClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Approve the above request", message: "Please select Yes or No", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Yes", style: .default) { _ in
            self.clickedYes()
        }
        let action2 = UIAlertAction(title: "No", style: .default) { _ in
            self.clickedNo()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
}

