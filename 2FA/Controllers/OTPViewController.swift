//
//  OTPViewController.swift
//  2FA
//
//  Created by Hafiz Fahad Hassan on 15/03/2022.
//

import UIKit

class OTPViewController: UIViewController {
    // MARK: - Outlets -
    @IBOutlet weak var txtCode: UITextField! {
        didSet {
            self.txtCode.delegate = self
            self.txtCode.tintColor = .black
            self.txtCode.placeholderColor(.gray)
        }
    }
    @IBOutlet weak var btnNext: UIButton! {
        didSet {
            self.btnNext.layer.cornerRadius = self.btnNext.frame.height / 2
            self.btnNext.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var lblTimer: UILabel!
    // MARK: - Initializers -
    var seconds:Double = Double()
    var timer:Timer = Timer()
    var msisdn: String = String()
    var phoneNumber: String = String()
    var countryCode: String = String()
    // MARK: - Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTimer.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1.0)
        self.btnResend.isUserInteractionEnabled = false
        seconds = 59
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:  #selector(OTPViewController.updateTimerLabel), userInfo: nil, repeats: true)
    }
    @objc func updateTimerLabel(){
        if(seconds == 0)
        {
            lblTimer.text = "00:00"
            timer.invalidate()
            self.lblTimer.isHidden = true
            self.btnResend.setTitleColor(UIColor(red: 15/255, green: 97/255, blue: 197/255, alpha: 1.0), for: .normal)
            self.btnResend.isUserInteractionEnabled = true
        }
        else
        {
            lblTimer.text = "(00:\(Int(seconds)))"
        }
        seconds -= 1
    }
    // MARK: - API's -
    func resendOTP(){
        let param:NSDictionary = ["msisdn":msisdn, "manufacturer":"Apple","OS":"ios","Version":"\(FAHelper.shared.osVersion)","DeviceId":FAHelper.shared.getDeviceToken(),"DateTime":"\(FAHelper.shared.current_Time)","PhNumber":self.phoneNumber,"CountryCode":self.countryCode, "callToken":FAHelper.shared.getCallToken(),"verification_type":UserDefaults.standard.isEmailOrPhone ?? "email","userEmail":UserDefaults.standard.userEmailAddress  ?? ""]
        URLHandler.sharedinstance.makeCall(url:Constant.shared.registerNo as String, param: param, completionHandler: {(responseObject, error) ->  () in
            if(error != nil)
            {
                self.view.makeToast(Constant.shared.errorMessage)
                print(error ?? "defaultValue")
            } else {
                print(responseObject ?? "response")
                let result = responseObject! as NSDictionary
                let errNo = result["errNum"] as! String
                let message = result["message"]
                if errNo == "0"{
                    self.btnResend.setTitleColor(UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1.0), for:.normal)
                    self.btnResend.isUserInteractionEnabled = false
                    self.lblTimer.isHidden = false
                    self.seconds = 59
                    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:  #selector(OTPViewController.updateTimerLabel), userInfo: nil, repeats: true)
                }
                else
                {
                    self.view.makeToast(message as! String)
                }
            }
        })
    }
    func otpCallingWithoutNumber(){
        self.view.endEditing(true)
        let param:NSDictionary = ["msisdn":msisdn,"code":"\(txtCode.text!)","manufacturer":"Apple","OS":"ios","Version":"\(FAHelper.shared.osVersion)","DeviceId":FAHelper.shared.getDeviceToken(),"DateTime":"\(FAHelper.shared.current_Time)","PhNumber":self.phoneNumber,"CountryCode":self.countryCode,"pushToken":"", "callToken":FAHelper.shared.getCallToken(),"verification_type":UserDefaults.standard.isEmailOrPhone ?? "email", "userEmail":UserDefaults.standard.userEmailAddress  ?? ""]
        URLHandler.sharedinstance.makeCall(url:Constant.shared.confirmOTP as String, param: param, completionHandler: {(responseObject, error) ->  () in
            if(error != nil)
            {
                print(error ?? "defaultValue")
                self.view.makeToast(Constant.shared.errorMessage)
            }
            else{
                print(responseObject ?? "response")
                self.view.makeToast("Successfully Verified from Email.")
            }
        })
    }
    func otpCalling() {
        self.view.endEditing(true)
        let param:NSDictionary = ["msisdn":msisdn,"code":"\(txtCode.text!)","manufacturer":"Apple","OS":"ios","Version":"\(FAHelper.shared.osVersion)","DeviceId":FAHelper.shared.getDeviceToken(),"DateTime":"\(FAHelper.shared.current_Time)","PhNumber":self.phoneNumber,"CountryCode":self.countryCode,"pushToken":"", "callToken":FAHelper.shared.getCallToken(),"verification_type":UserDefaults.standard.isEmailOrPhone ?? "email", "userEmail":UserDefaults.standard.userEmailAddress  ?? ""]
        URLHandler.sharedinstance.makeCall(url:Constant.shared.confirmOTP as String, param: param, completionHandler: {(responseObject, error) ->  () in
            if(error != nil)
            {
                print(error ?? "defaultValue")
                self.view.makeToast(Constant.shared.errorMessage)
            }
            else{
                print(responseObject ?? "response")
                self.view.makeToast("Successfully Verified from Phone.")
            }
        })

    }
    // MARK: - Actions -
    @IBAction func resendButtonPressed(_ sender: UIButton) {
        self.resendOTP()
    }
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if UserDefaults.standard.isEmailOrPhone == "email" {
            self.otpCallingWithoutNumber()
        } else {
            self.otpCalling()
        }
    }
}
extension OTPViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.keyboardType == .numberPad && string != "" {
            let numberStr: String = string
            let formatter: NumberFormatter = NumberFormatter()
            formatter.locale = Locale(identifier: "EN")
            if let final = formatter.number(from: numberStr) {
                textField.text =  "\(textField.text ?? "")\(final)"
            }
            return false
        }
        return true
    }
}
