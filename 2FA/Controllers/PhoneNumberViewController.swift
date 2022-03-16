//
//  PhoneNumberViewController.swift
//  2FA
//
//  Created by Hafiz Fahad Hassan on 14/03/2022.
//

import UIKit
import SKCountryPicker

class PhoneNumberViewController: UIViewController {
    // MARK: - Outlets -
    @IBOutlet weak var btnBack: UIButton! {
        didSet {
            self.btnBack.layer.cornerRadius = self.btnBack.frame.height / 2
            self.btnBack.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtPhoneNumber: UITextField! {
        didSet {
            self.txtPhoneNumber.placeholderColor(.gray)
        }
    }
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var flagImageView: UIImageView!
    // MARK: - Initializers -
    var countryCode: String = ""
    // MARK: - Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let country = CountryManager.shared.currentCountry else {
            self.lblCountryCode.text = ""
            self.flagImageView.image = nil
            return
        }
        self.countryCode = country.dialingCode ?? ""
        self.flagImageView.image = country.flag
        self.lblCountryCode.text = country.dialingCode
    }
    // MARK: - API's -
    func registerPhoneNo() {
        let param:NSDictionary = ["msisdn":"\(self.countryCode)\(self.txtPhoneNumber.text ?? "")","manufacturer":"Apple","OS":"ios","Version":"\(FAHelper.shared.osVersion)","DeviceId":FAHelper.shared.getDeviceToken(),"DateTime":"\(FAHelper.shared.current_Time)","PhNumber":"","CountryCode":"", "callToken":FAHelper.shared.getCallToken(),"verification_type":UserDefaults.standard.isEmailOrPhone ?? "email","userEmail": "", "emailVerified": "2"]
        URLHandler.sharedinstance.makeCall(url:Constant.shared.registerNo as String, param: param, completionHandler: {(responseObject, error) ->  () in
            if(error != nil)
            {
                self.view.makeToast(Constant.shared.errorMessage)
                self.view.endEditing(true)
                print(error ?? "defaultValue")
                
            }
            else {
                let result = responseObject! as NSDictionary
                let errNo = result["errNum"] as! String
                let message = result["message"] as! String
                if errNo == "0"{
                    let otpVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as!  OTPViewController
                    otpVC.countryCode = self.countryCode
                    otpVC.phoneNumber = self.txtPhoneNumber.text ?? ""
                    otpVC.msisdn = "\(self.countryCode)\(self.txtPhoneNumber.text ?? "")"
                    self.navigationController?.pushViewController(otpVC, animated: true)
                } else {
                    self.view.makeToast(message)
                }
            }
        })
    }
    // MARK: - Actions -
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.registerPhoneNo()
    }
    @IBAction func countryCodePressed(_ sender: UIButton) {
        let countryController = CountryPickerWithSectionViewController.presentController(
            on: self) {[weak self] (country: Country) in
                guard let self = self else { return }
                self.lblCountryCode.text = country.dialingCode
                self.flagImageView.image = country.flag
                self.countryCode = country.dialingCode ?? ""
            }
        countryController.flagStyle = .corner
        countryController.detailColor = UIColor.lightGray
    }
}
