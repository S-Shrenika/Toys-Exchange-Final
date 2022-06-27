//
//  swapViewController.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 09/06/22.
//

import UIKit

class swapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var toyid: Int!
    var ownerid: Int!
    var toydata = [Resonse]()
    override func viewDidLoad() {
        super.viewDidLoad()
        makegetreq()
        self.navigationController?.navigationBar.updateNavigationBarColor()
        self.navigationController?.navigationBar.tintColor = .white
    }
    func makegetreq(){
        guard let url = URL(string: "http://127.0.0.1:8000/toys") else{
            print("Error")
            return
        }
        getreq(url: url) { arraydata, error in
            DispatchQueue.main.async {
                self.toydata = arraydata!
                self.tableView.reloadData()
            }
        }
    }
    func getreq(url: URL,completion:@escaping ([Resonse]?, Error?) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)", forHTTPHeaderField: "Authorization")
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data{
                let result = try? JSONDecoder().decode([Resonse].self, from: data)
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
    func postreq(ownerid:Int, toyid:Int, exctoyid:Int, url: URL, completion:@escaping (Request?, Error?)->Void){
        let info: [String:Int] = [
            "ownerof_toy": ownerid,
            "toy_id":toyid,
            "exchange_toy_id": exctoyid
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: info, options: .fragmentsAllowed)
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data{
                let result = try? JSONDecoder().decode(Request.self, from: data)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toydata.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SwapTableViewCell
        cell.toyNameLbl.text = toydata[indexPath.row].toy_name
        cell.costLbl.text = "\(toydata[indexPath.row].cost)"
        cell.placeLbl.text = toydata[indexPath.row].place
        let created = toydata[indexPath.row].created_at
        cell.createdLbl.text = "\(created.dropLast(16))"
        cell.cardView()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 218
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: "http://127.0.0.1:8000/request") else{
            print("Error")
            return
        }
        let index = indexPath.row
        let id = toydata[index].toy_id
        postreq(ownerid: self.ownerid! ,toyid: self.toyid!, exctoyid: id, url: url) { msg, error in
            DispatchQueue.main.async {
            if msg != nil {
                let alert = UIAlertController(title: "Exchange Request Successful!", message: "Goto My Requests To Check Your Requests", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                }
            
            else{
                let alert = UIAlertController(title: "Exchange Request Fail!", message: error?.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
class SwapTableViewCell: UITableViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var createdLbl: UILabel!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    @IBOutlet weak var toyNameLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    func cardView(){
        cellView.layer.shadowColor = UIColor(red: 0, green: 38/255.0, blue: 119/255.0, alpha: 1.0).cgColor
        cellView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cellView.layer.shadowOpacity = 1.0
//        cellView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 5).cgPath
//        cellView.layer.shadowPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topRight, .bottomLeft], cornerRadii: CGSize(width: 2.0, height: 2.0)).cgPath
        //cellView.layer.maskedCorners = [.layerMaxXMinYCorner]
        cellView.layer.masksToBounds = false
        cellView.layer.cornerRadius = 10.0
    }
}
