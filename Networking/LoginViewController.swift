//
//  LoginViewController.swift
//  Networking
//
//  Created by Felix Falkovsky on 02.10.2020.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
     let customFBLoginButtom: UIButton = {
        let loginButton = UIButton()
        loginButton.backgroundColor = UIColor(hex: "#3B5999", alpha: 1)
        loginButton.setTitle("Login with Facebook", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.frame = CGRect(x:  42, y: 600 , width: 320, height: 40)
        loginButton.layer.cornerRadius = 20
        loginButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        return loginButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        let loginButton = FBLoginButton()
      //  loginButton.permissions = ["public_profile", "email"]
        loginButton.frame = CGRect(x: view.center.x - 160, y: 680, width: 320, height: 40)
        loginButton.layer.cornerRadius = 20
        loginButton.clipsToBounds = true
        loginButton.delegate = self
        view.addSubview(loginButton)
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
    }
    private func setupButton() {
        view.addSubview(customFBLoginButtom)
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
    
    @objc private func handleCustomFBLogin() {
        LoginManager().logIn(permissions: ["email", "public_profile"], from: self) { (result, error) in
            if let error = error {
                print("*** ERROR \(error) ***")
                return
            }
            
            guard let result = result else { return }
            
            if result.isCancelled { return }
            else {
                self.signIntoFirebase()
                self.openMainViewController()
            }
        }
    }
     
    // Вход в Firebase через Facebook
    private func signIntoFirebase() {
        let accessToken = AccessToken.current
        guard let accessTokenString = accessToken?.tokenString  else { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials) { (user, error) in
            if let error = error {
                print("*** Something went wrong with our Facebook user, \(error) ***")
                return
            }
            print("Successfully logged in with our FB user:", user!)
        }
    }
}
    
