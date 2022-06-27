//
//  SettingsViewController.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 07/06/22.
//

import UIKit
import WhatsNewKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var arr = ["About Us", "Logout"]
    var arr1 = ["Version"]
    var arr2 = ["1.0"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.updateNavigationBarColor()
        self.navigationController?.navigationBar.tintColor = .white
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell1
            cell.lbl.text = self.arr[0]
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! TableViewCell2
            cell.lbl1.text = arr1[0]
            cell.lbl2.text = arr2[0]
            cell.isUserInteractionEnabled = false
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell1
            cell.lbl.text = self.arr[1]
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            performSegue(withIdentifier: "aboutus", sender: self)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        if indexPath.row == 2{
            print("logout")
            performSegue(withIdentifier: "logoutsegue", sender: self)
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "firstvc")
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true, completion: nil)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
class TableViewCell1: UITableViewCell{
    @IBOutlet weak var lbl: UILabel!
}
class TableViewCell2: UITableViewCell{
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
}
