//
//  AboutusViewController.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 08/06/22.
//

import UIKit

class AboutusViewController: UIViewController {
    @IBOutlet weak var txtView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.updateNavigationBarColor()
        self.navigationController?.navigationBar.tintColor = .white
        txtView.text = "A toy exchange app where people can exchange their toys. It saves alot of money"
    }
}
