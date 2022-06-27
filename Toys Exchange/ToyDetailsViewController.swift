//
//  ToyDetailsViewController.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 03/06/22.
//

import UIKit

class ToyDetailsViewController: UIViewController {
    var toyData: Resonse!
    var toyid: Int!
    @IBOutlet weak var detailview: UIView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var ownerLbl: UILabel!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    @IBOutlet weak var toyNameLbl: UILabel!
    @IBOutlet weak var toyImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        toyNameLbl.textColor = .white
        costLbl.textColor = .white
        placeLbl.textColor = .white
        ownerLbl.textColor = .white
        descLbl.textColor = .white
        detailview.backgroundColor = UIColor(red: 0, green: 38/255.0, blue: 119/255.0, alpha: 1.0).withAlphaComponent(0.75)
        detailview.isOpaque = false
        detailview.layer.shadowColor = UIColor.white.cgColor
        detailview.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        detailview.layer.shadowOpacity = 1.0
        //detailview.layer.maskedCorners = [.layerMaxXMinYCorner]
        detailview.layer.masksToBounds = false
        detailview.layer.cornerRadius = 40.0
//        toyNameLbl.text = toyData.toy_name
//        costLbl.text = "\(String(describing: toyData.cost))"
//        placeLbl.text = toyData.place
//        ownerLbl.text = toyData.owner.email
//        descLbl.text = toyData.description
        makegetreq()
        self.navigationController?.navigationBar.updateNavigationBarColor()
        self.navigationController?.navigationBar.tintColor = .white
    }
    func makegetreq(){
        guard let url = URL(string: "http://127.0.0.1:8000/toys/\(toyid!)") else{
            print("Error")
            return
        }
        getreq(url: url) { arraydata, error in
            DispatchQueue.main.async {
                self.toyNameLbl.text = arraydata!.toy_name
                self.costLbl.text = "\(String(describing: arraydata!.cost))"
                self.placeLbl.text = arraydata!.place
                self.ownerLbl.text = arraydata!.owner.email
                self.descLbl.text = arraydata!.description
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
    @IBAction func swapclicked(_ sender: UIButton) {
        performSegue(withIdentifier: "swap", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! swapViewController
        dest.toyid = self.toyid
        dest.ownerid = self.toyData.owner_id
    }
}
