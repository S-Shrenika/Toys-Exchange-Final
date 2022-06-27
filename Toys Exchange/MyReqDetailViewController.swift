//
//  MyReqDetailViewController.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 09/06/22.
//

import UIKit

class MyReqDetailViewController: UIViewController {
    var toyData: Resp!
    var ownerid: Int!
    var excid: Int!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var cost2: UILabel!
    @IBOutlet weak var place2: UILabel!
    @IBOutlet weak var toyname2: UILabel!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var owneremail: UILabel!
    @IBOutlet weak var ownername: UILabel!
    @IBOutlet weak var place1: UILabel!
    @IBOutlet weak var cost1: UILabel!
    @IBOutlet weak var toyname1: UILabel!
    @IBOutlet weak var img1: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        toyname2.textColor = .white
        place2.textColor = .white
        cost2.textColor = .white
        view1.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view1.layer.shadowOpacity = 1.0
        view1.layer.masksToBounds = false
        view1.layer.cornerRadius = 10.0
        view1.layer.shadowColor = UIColor.white.cgColor
        view3.backgroundColor = UIColor(red: 0, green: 38/255.0, blue: 119/255.0, alpha: 1.0).withAlphaComponent(0.50)
        view3.isOpaque = false
        view3.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view3.layer.shadowOpacity = 1.0
        view3.layer.masksToBounds = false
        view3.layer.cornerRadius = 20.0
        view3.layer.shadowColor = UIColor.gray.cgColor
        toyname1.text = toyData.Toy.toy_name
        cost1.text = "\(toyData.Toy.cost)"
        place1.text = toyData.Toy.place
        self.ownerid = toyData.Toy.owner_id
        self.excid = toyData.Request.exchange_toy_id
        makegetreq()
        makegetreq1()
        self.navigationController?.navigationBar.updateNavigationBarColor()
        self.navigationController?.navigationBar.tintColor = .white
    }
    func makegetreq1(){
        let id = self.ownerid
        guard let url = URL(string: "http://127.0.0.1:8000/user/\(id!)") else{
            print("Error")
            return
        }
        getreq1(url: url) { arraydata, error in
            DispatchQueue.main.async {
                self.owneremail.text = arraydata!.email
                self.ownername.text = arraydata!.name
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
    func makegetreq(){
        let toyid = self.excid
        guard let url = URL(string: "http://127.0.0.1:8000/toys/\(toyid!)") else{
            print("Error")
            return
        }
        getreq(url: url) { arraydata, error in
            DispatchQueue.main.async {
                self.toyname2.text = arraydata!.toy_name
                self.place2.text = arraydata!.place
                self.cost2.text = "\(arraydata!.cost)"
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
}
