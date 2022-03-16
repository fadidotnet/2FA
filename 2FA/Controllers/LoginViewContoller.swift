//
//  LoginViewContoller.swift
//  2FA
//
//  Created by Hafiz Fahad Hassan on 14/03/2022.
//

import UIKit

class LoginViewContoller: UIViewController {
    // MARK: - Outlets -
    @IBOutlet weak var txtEmail: UITextField! {
        didSet {
            self.txtEmail.placeholderColor(.gray)
        }
    }
    // MARK: - Initializers -
    var signUp = SignUp()
    // MARK: - Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    private func showNextController(_ isForEmail: Bool) {
        self.view.endEditing(true)
        UserDefaults.standard.isEmailOrPhone = isForEmail ? "email" : "phone"
        if isForEmail {
            if let email = txtEmail.text, FAHelper.shared.isValidEmailAddress(emailAddressString: email) {
                UserDefaults.standard.userEmailAddress = email
                registerPhoneNo()
            } else {
                self.view.makeToast("Please enter valid email")
            }
        } else {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SecondLoginViewController") as! PhoneNumberViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - APIs -
    func registerPhoneNo() {
        let param:NSDictionary = ["msisdn":"","manufacturer":"Apple","OS":"ios","Version":"\(FAHelper.shared.osVersion)","DeviceId":FAHelper.shared.getDeviceToken(),"DateTime":"\(FAHelper.shared.current_Time)","PhNumber":"","CountryCode":"", "callToken":FAHelper.shared.getCallToken(),"verification_type":UserDefaults.standard.isEmailOrPhone ?? "email","userEmail": txtEmail.text!, "emailVerified": "2"]
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
                    self.signUp.code =  FAHelper.shared.checkNullvalue(value: result["code"] as AnyObject?)
                    self.signUp.user_Id =  FAHelper.shared.checkNullvalue(value: result["_id"] as AnyObject?)
                    self.signUp.profilePic = FAHelper.shared.checkNullvalue(value: result["ProfilePic"]as AnyObject?)
                    self.signUp.status = FAHelper.shared.checkNullvalue(value: result["Status"] as AnyObject?)
                    let otpVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as!  OTPViewController
                    
                    self.navigationController?.pushViewController(otpVC, animated: true)
                } else {
                    self.view.makeToast(message)
                }
            }
        })
    }
    // MARK: - Actions -
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.showNextController(true)
    }
    @IBAction func phoneButtonPressed(_ sender: UIButton) {
        self.showNextController(false)
    }
}

