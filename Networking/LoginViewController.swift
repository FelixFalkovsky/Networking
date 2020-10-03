//
//  LoginViewController.swift
//  Networking
//
//  Created by Felix Falkovsky on 02.10.2020.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController {
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBLoginButton()
      //  loginButton.permissions = ["public_profile", "email"]
        loginButton.frame = CGRect(x: view.center.x - 160, y: 680, width: 320, height: 40)
        loginButton.layer.cornerRadius = 20
        loginButton.clipsToBounds = true
        loginButton.delegate = self
        view.addSubview(loginButton)
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
}

//MARK: Facebook SDK
extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error! )
            return
        }
        guard AccessToken.isCurrentAccessTokenActive != false else { return }
        openMainViewController()
        print("Successfully logged in with Facebook ... ")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Did log out of Facebook")
    }
    
    private func openMainViewController() {
    dismiss(animated: true)
    }
}
    
