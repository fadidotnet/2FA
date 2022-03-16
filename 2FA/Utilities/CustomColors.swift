//
//  CustomColors.swift
//  2FA
//
//  Created by Hafiz Fahad Hassan on 14/03/2022.
//

import UIKit

final class CustomColor: NSObject {
    
    static let shared = CustomColor()
    // Initialization
    private override init() {}
    
    let themeColor = FAHelper.shared.UIColorFromHex(0x000000)
    
    
}
