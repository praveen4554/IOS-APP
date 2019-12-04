//
//  UIViewController+Extension.swift
//  securityKey
//
//  Created by praveenkumar on 26/11/19.
//  Copyright © 2019 praveenkumar. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = "Warning", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
