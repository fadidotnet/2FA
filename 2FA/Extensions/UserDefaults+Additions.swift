//
//  UserDefaults+Additions.swift
//  2FA
//
//  Created by Hafiz Fahad Hassan on 14/03/2022.
//

import UIKit

extension UserDefaults {
    var isEmailOrPhone: String? {
        get {
            return UserDefaults.standard.value(forKey: "isEmailOrPhone") as? String
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "isEmailOrPhone")
            UserDefaults.standard.synchronize()
        }
    }
    var userEmailAddress: String? {
        get {
            return UserDefaults.standard.value(forKey: "userEmailAddress") as? String
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "userEmailAddress")
            UserDefaults.standard.synchronize()
        }
    }
}
