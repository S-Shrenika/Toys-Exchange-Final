//
//  ViewController.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 09/05/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var logoImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    @IBAction func helpClicked(_ sender: UIButton) {
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

