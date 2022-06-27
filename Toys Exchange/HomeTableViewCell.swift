//
//  HomeTableViewCell.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 01/06/22.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var toyView: UIView!
    @IBOutlet weak var toyImage: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var ownerLbl: UILabel!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var toyCostLbl: UILabel!
    @IBOutlet weak var toyNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        toyView.layer.shadowColor = UIColor.gray.cgColor
        toyView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        toyView.layer.shadowOpacity = 1.0
//        toyView.layer.maskedCorners = [.layerMaxXMinYCorner]
        toyView.layer.masksToBounds = false
        toyView.layer.cornerRadius = 10.0
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
