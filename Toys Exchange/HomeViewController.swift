//
//  HomeViewController.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 01/06/22.
//

import UIKit
import WhatsNewKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var toydata = [Resonse]()
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInitialVc()
        makegetreq()
        makegetreq2()
        self.navigationController?.navigationBar.updateNavigationBarColor()
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    func checkInitialVc() {
        UserDefaults.standard.set(true, forKey: "firstTime")
        let firstTime = UserDefaults.standard.bool(forKey: "firstTime")
        if firstTime {
            UserDefaults.standard.set(false, forKey: "firstTime")
            let whatsNew = WhatsNew(title: "Toys", items: [WhatsNew.Item(title: "View Toys", subtitle: "You can view toys of people across country and swap them", image: UIImage(named: "toys1")),
                                                           WhatsNew.Item(title: "Swap Toys", subtitle: "Select a toy and swap with a toy of yours", image: UIImage(named: "swap"))])
            let vc = WhatsNewViewController(whatsNew: whatsNew)
            vc.isModalInPresentation = true
            present(vc, animated: true, completion: nil)
        }
    }
//    override  func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let whatsNew = WhatsNew(title: "Toys", items: [WhatsNew.Item(title: "View Toys", subtitle: "You can view toys of people across country and swap them", image: UIImage(named: "toys1")),
//                                                       WhatsNew.Item(title: "Swap Toys", subtitle: "Select a toy and swap with a toy of yours", image: UIImage(named: "swap"))])
//        guard let vc = WhatsNewViewController(whatsNew: whatsNew, versionStore: KeyValueWhatsNewVersionStore()) else {return}
////        let vc = WhatsNewViewController(whatsNew: whatsNew)
//        vc.isModalInPresentation = true
//        present(vc, animated: true, completion: nil)
//    }
    func makegetreq2(){
        let ownr = UserDefaults.standard.object(forKey: "ownerId")
        guard let url = URL(string: "http://127.0.0.1:8000/user/\(ownr!)") else{
            print("Error")
            return
        }
        getreq2(url: url) { arraydata, error in
            DispatchQueue.main.async {
                self.welcomeLbl.text = "Welcome, \(arraydata!.name)!"
                self.welcomeLbl.textColor = UIColor(red: 0, green: 38/255.0, blue: 119/255.0, alpha: 1.0)
            }
        }
    }
    func getreq2(url: URL,completion:@escaping (ownerDetails?, Error?) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)", forHTTPHeaderField: "Authorization")
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
        guard let url = URL(string: "http://127.0.0.1:8000/alltoys") else{
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
                //self.toydata = result!
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HomeTableViewCell
        cell.toyNameLbl.text = toydata[indexPath.row].toy_name
        cell.toyCostLbl.text = "\(toydata[indexPath.row].cost)"
        cell.placeLbl.text = toydata[indexPath.row].place
        cell.ownerLbl.text = toydata[indexPath.row].owner.email
        let created = toydata[indexPath.row].created_at
        cell.dateLbl.text = "\(created.dropLast(16))"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "details", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! ToyDetailsViewController
        dest.toyData = toydata[tableView.indexPathForSelectedRow!.row]
        dest.toyid = toydata[tableView.indexPathForSelectedRow!.row].toy_id
    }
}

