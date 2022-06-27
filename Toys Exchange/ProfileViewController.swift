//
//  ProfileViewController.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 07/06/22.
//

import UIKit
import WhatsNewKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var arr = ["My Details", "My Requests", "My Approvals"]
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInitialVc()
        self.navigationController?.navigationBar.updateNavigationBarColor()
        self.navigationController?.navigationBar.tintColor = .white
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
//        let whatsNew = WhatsNew(title: " Profile", items: [WhatsNew.Item(title: "My Deatils", subtitle: "View all your personal information", image: UIImage(named: "profile")),
//        WhatsNew.Item(title: "Requests", subtitle: "View all your requested toys along with owner details", image: UIImage(named: "req")),
//        WhatsNew.Item(title: "Approvals", subtitle: "Approve requests from various toy owners for swapping toys and view them", image: UIImage(named: "approve")),
//                                                          ])
//        guard let vc = WhatsNewViewController(whatsNew: whatsNew, versionStore: KeyValueWhatsNewVersionStore()) else {return}
////        let vc = WhatsNewViewController(whatsNew: whatsNew)
//        vc.isModalInPresentation = true
//        present(vc, animated: true, completion: nil)
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProfileTableViewCell
        cell.lbl.text = arr[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = indexPath.row
        switch selected
        {
        case 0: performSegue(withIdentifier: "1", sender: self)
        case 1: performSegue(withIdentifier: "2", sender: self)
        case 2: performSegue(withIdentifier: "3", sender: self)
        default: break
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
class ProfileTableViewCell: UITableViewCell{
    @IBOutlet weak var lbl: UILabel!
}
