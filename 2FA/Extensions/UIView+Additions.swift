//
//  UIView+Additions.swift
//  2FA
//
//  Created by Hafiz Fahad Hassan on 14/03/2022.
//

import UIKit
import Toast_Swift

extension UIView {
    func makeToast(_ message: String) {
        self.makeToast(message, duration: 2.0, position: .bottom)
    }
}
