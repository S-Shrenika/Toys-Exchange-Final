//
//  Ext.swift
//  Toys Exchange
//
//  Created by Shrenika, Soma on 20/06/22.
//

import Foundation
import UIKit

extension UINavigationBar {
    func updateNavigationBarColor() {
        let bar = UINavigationBarAppearance()
        bar.backgroundColor = UIColor(red: 0, green: 38/255.0, blue: 119/255.0, alpha: 1.0)
        bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.standardAppearance = bar
        self.scrollEdgeAppearance = bar
        self.isTranslucent = false
    }
}
