//
//  SignInViewController.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 09/05/22.
//

import UIKit
class SignInViewController: UIViewController {
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    var activeTextField:UITextField!
    var activityIndicator = UIActivityIndicatorView(style: .large)
    struct Response: Codable{
        var access_token: String
        var token_type: String
        var owner_id: Int
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.center = view.center
        self.view.addSubview(activityIndicator)
        textFld(textField: emailTxtFld)
        textFld(textField: passwordTxtFld)
        emailTxtFld.delegate = self
        passwordTxtFld.delegate = self
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func makepostreq(){
        guard let url = URL(string: "http://127.0.0.1:8000/login") else{
            print("Error")
            return
        }
        loginpostreq(url: url) { jsondata, error in
            //print(jsondata)
            let accesstoken = jsondata?.access_token
            UserDefaults.standard.set(accesstoken, forKey: "accessToken")
            let ownerid = jsondata?.owner_id
            UserDefaults.standard.set(ownerid, forKey: "ownerId")
            DispatchQueue.main.async {
                if accesstoken != nil{
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "home", sender: self)
                }
                else{
                    let alert = UIAlertController(title: "Wrong Credentials!", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    func loginpostreq(url: URL, completionHandler:@escaping (Response?, Error?)->Void){
        let email = emailTxtFld.text!
        let pwd = passwordTxtFld.text!
        let info: [String:String] = [
            "email":"\(email)",
            "password":"\(pwd)"
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: info, options: .fragmentsAllowed)
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data{
                let jsonresponse = try? JSONDecoder().decode(Response.self, from: data)
                if jsonresponse != nil {
                    completionHandler(jsonresponse, nil)
                }
                else{
                    completionHandler(nil, error)
                }
            }
            else{
                completionHandler(nil, error)
            }
        }.resume()
    }
    
    @objc func keyboardShown(notification:Notification){
        let info:NSDictionary = notification.userInfo as! NSDictionary
        let keyboardsize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.height - keyboardsize.height
        let editingTextFieldY = activeTextField.convert(activeTextField.bounds, to:self.view).minY
        if self.view.frame.minY >= 0{
            if editingTextFieldY>keyboardY-50
            {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y-(editingTextFieldY-(keyboardY-80)), width: self.view.bounds.width, height: self.view.bounds.height)
                }, completion: nil)
            }
        }
    }
    @objc func keyboardHidden(notification:Notification){
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
    @IBAction func signinClicked(_ sender: UIButton) {
        makepostreq()
        self.activityIndicator.startAnimating()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
extension SignInViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
