//
//  MyToysViewController.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 06/06/22.
//

import UIKit
import WhatsNewKit

class MyToysViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableview: UITableView!
    var toydata = [Resonse]()
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInitialVc()
        makegetreq()
        self.navigationController?.navigationBar.updateNavigationBarColor()
        self.navigationController?.navigationBar.tintColor = .white
    }
    func checkInitialVc() {
        UserDefaults.standard.set(true, forKey: "firstTime")
        let firstTime = UserDefaults.standard.bool(forKey: "firstTime")
        if firstTime {
            UserDefaults.standard.set(false, forKey: "firstTime")
            let whatsNew = WhatsNew(title: "My Toys", items: [WhatsNew.Item(title: "My Toys", subtitle: "You can view all of  your toys", image: UIImage(named: "view")),
                                                           WhatsNew.Item(title: "Edit Toys", subtitle: "Edit the details of your toys", image: UIImage(named: "edit1"))])
            let vc = WhatsNewViewController(whatsNew: whatsNew)
            vc.isModalInPresentation = true
            present(vc, animated: true, completion: nil)
        }
    }
//    override  func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let whatsNew = WhatsNew(title: " My Toys", items: [WhatsNew.Item(title: "View Toys", subtitle: "View all your toys", image: UIImage(named: "view")),
//                                                           WhatsNew.Item(title: "Edit Toys", subtitle: "Edit the details of your toys", image: UIImage(named: "edit1"))
//                                                          ])
//        guard let vc = WhatsNewViewController(whatsNew: whatsNew, versionStore: KeyValueWhatsNewVersionStore()) else {return}
////        let vc = WhatsNewViewController(whatsNew: whatsNew)
//        vc.isModalInPresentation = true
//        present(vc, animated: true, completion: nil)
//    }
    override func viewWillAppear(_ animated: Bool) {
        makegetreq()
    }
    func makegetreq(){
        guard let url = URL(string: "http://127.0.0.1:8000/toys") else{
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
    func delreq(id: Int,completion:@escaping (Error?) -> Void){
        guard let url = URL(string: "http://127.0.0.1:8000/toys/\(id)") else{
            print("Error")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)", forHTTPHeaderField: "Authorization")
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toydata.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MytoysTableViewCell
        cell.toynameLbl.text = toydata[indexPath.row].toy_name
        cell.costLbl.text = "\(toydata[indexPath.row].cost)"
        cell.placeLbl.text = toydata[indexPath.row].place
        let created = toydata[indexPath.row].created_at
        cell.dateLbl.text = "\(created.dropLast(16))"
        cell.cardView()
//        cell.imageview.clipsToBounds = true
//        cell.imageview.contentMode = .scaleAspectFit
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toydetail", sender: self)
        self.tableview.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.tableview.beginUpdates()
            let toy = self.toydata[indexPath.row].toy_id
            delreq(id: toy) { err in
                if err != nil{
                    print("Failed")
                    return
                }
                print("Success")
                self.toydata.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self.tableview.deleteRows(at: [indexPath], with: .fade)
                    self.tableview.endUpdates()
                }
        }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! MyToysDetailsViewController
        dest.toyid = toydata[tableview.indexPathForSelectedRow!.row].toy_id
    }
}
class MytoysTableViewCell: UITableViewCell{
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var toynameLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    func cardView(){
        newView.layer.shadowColor = UIColor(red: 0, green: 38/255.0, blue: 119/255.0, alpha: 1.0).cgColor
        newView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        newView.layer.shadowOpacity = 1.0
        newView.layer.masksToBounds = false
        newView.layer.cornerRadius = 10.0
    }
}
