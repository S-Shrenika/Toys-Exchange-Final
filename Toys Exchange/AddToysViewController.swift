//
//  AddToysViewController.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 01/06/22.
//

import UIKit
import WhatsNewKit

class AddToysViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var str: String = ""
    @IBOutlet weak var addedLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var namelbl = ["Toy Name", "Cost", "Place", "Description", "Add Photo"]
    var toy_name: String?
    var place:String?
    var cost: String?
    var desc: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInitialVc()
        self.navigationController?.navigationBar.updateNavigationBarColor()
        self.navigationController?.navigationBar.tintColor = .white
        addedLbl.alpha = 0
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismisskeyboard))
        self.view.addGestureRecognizer(tap)
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
//        let whatsNew = WhatsNew(title: " Add Toys", items: [WhatsNew.Item(title: "Add Toys", subtitle: "Add your toys so as to let people request for them", image: UIImage(named: "add"))])
////        let vc = WhatsNewViewController(whatsNew: whatsNew)
//        guard let vc = WhatsNewViewController(whatsNew: whatsNew, versionStore: KeyValueWhatsNewVersionStore()) else {return}
//        vc.isModalInPresentation = true
//        present(vc, animated: true, completion: nil)
//    }
    @objc func dismisskeyboard(){
        self.view.endEditing(true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namelbl.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 ||  indexPath.row == 2 || indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
            cell.nameLbl.text = namelbl[indexPath.row]
            cell.textField.tag = indexPath.row
            cell.textField.delegate = self
            return cell
        }
         else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
            cell.nameLbl.text = namelbl[indexPath.row]
            cell.textField.tag = indexPath.row
            cell.textField.delegate = self
            cell.textField.keyboardType = .numberPad
            return cell
        }
//        else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! PhotoTableViewCell
//            cell.lbl.text = "Add Photo"
//            cell.addBtn.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
//            return  cell
//        }
    }
//    @objc func addTapped(){
//        let action = UIAlertController(title: "Select Image", message: "Camera or Gallery", preferredStyle: .actionSheet)
//        let camera = UIAlertAction(title: "Camers", style: .default) { _ in
//            self.showImagePicker(selectedSource: .camera)
//        }
//        let gallery = UIAlertAction(title: "Gallery", style: .default) { _ in
//            self.showImagePicker(selectedSource: .photoLibrary)
//        }
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        action.addAction(camera)
//        action.addAction(gallery)
//        action.addAction(cancel)
//        present(action, animated: true, completion: nil)
//
//    }
    func showImagePicker(selectedSource: UIImagePickerController.SourceType){
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else{
            print("Selected source not available")
            return
        }
        let imagepickerCntroller = UIImagePickerController()
        imagepickerCntroller.delegate = self
        imagepickerCntroller.sourceType = selectedSource
        imagepickerCntroller.allowsEditing = true
        present(imagepickerCntroller, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage{
            let img = selectedImage.jpegData(compressionQuality: 1)
            let base64str = img?.base64EncodedString(options: .lineLength64Characters)
            self.str = base64str ?? "No data"
            print(str)
        }
        else{
            print("Image not found")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !textField.text!.isEmpty 
         {
          if textField.tag == 0{
              toy_name = textField.text!
          }else if textField.tag == 1{
              
                cost = textField.text!
          }else if textField.tag == 2{
              place = textField.text!
          }else{
              desc = textField.text!
          }
    }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0{
            toy_name = ""}
        else if textField.tag == 1{
            cost = ""}
        else if textField.tag == 2{
            place = ""}
        else{
            desc = ""}
    }
    func makepostreq(){
        guard let url = URL(string: "http://127.0.0.1:8000/toys") else{
            print("Error")
            return
        }
        postreq(url: url) { jsondata, error in
            DispatchQueue.main.async {
                if jsondata != nil{
                    self.addedLbl.alpha = 1
                    self.addedLbl.text = "Toy added Successfully"
                    
                }
                else{
                    self.addedLbl.alpha = 1
                    self.addedLbl.text = "Failed to add toy"
                }
            }
        }
    }
    func postreq(url: URL, completion:@escaping (Resonse?, Error?)->Void){
        let info: [String:String?] = [
            "toy_name":toy_name ,
            "cost":cost,
            "place":place,
            "description":desc
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
    @IBAction func submitClicked(_ sender: UIButton) {
        if toy_name == nil || place == nil || cost == nil || desc == nil {
            let alert = UIAlertController(title: "Alert", message: "All fields are required to be filled in", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
                }
        else{
            makepostreq()
    }
    }
}
class TableViewCell: UITableViewCell{
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textField.frame.height - 1, width: textField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor(red: 0, green: 38/255.0, blue: 119/255.0, alpha: 1.0).cgColor
        self.textField.borderStyle = UITextField.BorderStyle.none
        self.textField.layer.addSublayer(bottomLine)
    }
}
class PhotoTableViewCell: UITableViewCell{
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var lbl: UILabel!
    
}
