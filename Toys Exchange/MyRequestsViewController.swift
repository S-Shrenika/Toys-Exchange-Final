//
//  MyRequestsViewController.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 09/06/22.
//

import UIKit

class MyRequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableview: UITableView!
    var toydata = [Resp]()
    var val = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        makegetreq()
        self.navigationController?.navigationBar.updateNavigationBarColor()
        self.navigationController?.navigationBar.tintColor = .white
    }
    func makegetreq(){
        guard let url = URL(string: "http://127.0.0.1:8000/requests") else{
            print("Error")
            return
        }
        getreq(url: url) { arraydata, error in
            DispatchQueue.main.async {
                self.toydata = arraydata!
                self.tableview.reloadData()
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
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell") as! MyReqTableViewCell
        cell.toyname.text = toydata[indexPath.row].Toy.toy_name
        cell.cost.text = "\(toydata[indexPath.row].Toy.cost)"
        cell.place.text = toydata[indexPath.row].Toy.place
        cell.desc.text = toydata[indexPath.row].Toy.description
        //cell.exchangeToyName.text = "\(toydata[indexPath.row].Request.exchange_toy_id)"
        cell.checkStatus.tag = indexPath.row
        cell.checkStatus.addTarget(self, action: #selector(statusBtnTapped(sender:)), for: .touchUpInside)
        cell.cardView()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showowner", sender: self)
        self.tableview.deselectRow(at: indexPath, animated: false)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showowner"{
            let dest = segue.destination as! MyReqDetailViewController
            dest.toyData = toydata[tableview.indexPathForSelectedRow!.row]
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    @objc func statusBtnTapped(sender: UIButton){
        //print(sender.tag)
        let indexx = sender.tag
        self.val = self.toydata[indexx].Request.approval ?? "not found"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "status") as! StausViewController
        if let presentationController = vc.presentationController as? UISheetPresentationController {
                    presentationController.detents = [.medium()]
                }
        vc.arrvVal = val
        self.present(vc, animated: true)
    }
}
class MyReqTableViewCell: UITableViewCell {
    @IBOutlet weak var reqView: UIView!
    @IBOutlet weak var checkStatus: UIButton!
    @IBOutlet weak var exchangeToyName: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var toyname: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var img: UIImageView!
    func cardView(){
        reqView.layer.shadowColor = UIColor(red: 0, green: 38/255.0, blue: 119/255.0, alpha: 1.0).cgColor
        reqView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        reqView.layer.shadowOpacity = 1.0
        reqView.layer.masksToBounds = false
        reqView.layer.cornerRadius = 10.0
    }
}
    
