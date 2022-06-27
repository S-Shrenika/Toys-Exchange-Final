//
//  StausViewController.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 21/06/22.
//

import UIKit

class StausViewController: UIViewController {
    var arrvVal: String = ""
    @IBOutlet weak var apprvRejLbl: UILabel!
    @IBOutlet weak var slider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.isUserInteractionEnabled = false
        if arrvVal == "yes"{
            slider.setValue(1, animated: true)
            apprvRejLbl.text = "Approved"
        }
        else if arrvVal == "no"{
            slider.setValue(1, animated: true)
            apprvRejLbl.text = "Rejected"
        }
        else{
            slider.setValue(0.5, animated: true)
        }
    }
}
