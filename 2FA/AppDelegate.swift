//
//  AppDelegate.swift
//  2FA
//
//  Created by Hafiz Fahad Hassan on 14/03/2022.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window:UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        self.setupIQKeyboardManager()
        self.setupNavigationAppearance()
        return true
    }
    // MARK: - Methods -
    private func setupNavigationAppearance() {
        UINavigationBar.appearance().tintColor = CustomColor.shared.themeColor
        UIBarButtonItem.appearance().tintColor = CustomColor.shared.themeColor
        UIToolbar.appearance().tintColor = CustomColor.shared.themeColor
    }
    private func setupIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
}

