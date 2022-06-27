//
//  ApprovalViewController.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 13/06/22.
//

import UIKit

class ApprovalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var toydata = [Resp]()
    override func viewDidLoad() {
        super.viewDidLoad()
        makegetreq()
        self.navigationController?.navigationBar.updateNavigationBarColor()
        self.navigationController?.navigationBar.tintColor = .white
    }
    override func viewWillAppear(_ animated: Bool) {
        makegetreq()
    }
    func makegetreq(){
        guard let url = URL(string: "http://127.0.0.1:8000/approval") else{
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
    func getreq(url: URL,completion:@escaping ([Resp]?, Error?) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)", forHTTPHeaderField: "Authorization")
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data{
                let result = try? JSONDecoder().decode([Resp].self, from: data)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ApproveTableViewCell
        cell.toyName.text = toydata[indexPath.row].Toy.toy_name
        cell.place.text = toydata[indexPath.row].Toy.place
        cell.cost.text = "\(toydata[indexPath.row].Toy.cost)"
        cell.desc.text = toydata[indexPath.row].Toy.description
        let created = toydata[indexPath.row].Toy.created_at
        cell.createdDate.text = "\(created.dropLast(16))"
        cell.cardView()
        let apprv = toydata[indexPath.row].Request.approval
        if apprv == "yes"{
            cell.apprvStatus.text = "✅"
        }
        else if apprv == "no"{
            cell.apprvStatus.text = "❌"
        }
        else{
            cell.apprvStatus.text = "⌛"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(toydata[tableView.indexPathForSelectedRow!.row])
        performSegue(withIdentifier: "approvedetail", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! ApproveDetailViewController
        dest.toyData = toydata[tableView.indexPathForSelectedRow!.row]
    }
}
class ApproveTableViewCell: UITableViewCell {
    @IBOutlet weak var apprView: UIView!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var toyName: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var apprvStatus: UILabel!
    func cardView(){
        apprView.layer.shadowColor = UIColor(red: 0, green: 38/255.0, blue: 119/255.0, alpha: 1.0).cgColor
        apprView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        apprView.layer.shadowOpacity = 1.0
        apprView.layer.masksToBounds = false
        apprView.layer.cornerRadius = 10.0
    }
}
