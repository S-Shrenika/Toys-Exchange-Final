//
//  MyDetailsViewController.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 08/06/22.
//

import UIKit

class MyDetailsViewController: UIViewController {
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var createdOnLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        makegetreq()
        self.navigationController?.navigationBar.updateNavigationBarColor()
        self.navigationController?.navigationBar.tintColor = .white
    }
    func makegetreq(){
        let id = UserDefaults.standard.object(forKey: "ownerId")
        guard let url = URL(string: "http://127.0.0.1:8000/user/\(id!)") else{
            print("Error")
            return
        }
        getreq(url: url) { arraydata, error in
            DispatchQueue.main.async {
                self.emailLbl.text = arraydata!.email
                let created = arraydata!.created_at.dropLast(16)
                self.createdOnLbl.text = "\(created)"
                self.nameLbl.text = arraydata!.name
            }
        }
    }
    func getreq(url: URL,completion:@escaping (ownerDetails?, Error?) -> Void){
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
}
