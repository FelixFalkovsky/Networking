//
//  UserProfileVC.swift
//  Networking
//
//  Created by Felix Falkovsky on 03.10.2020.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class UserProfileVC: UIViewController {
    

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

extension UserProfileVC: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error! )
            return
        }
   
        print("Successfully logged in with Facebook ... ")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Did log out of Facebook")
        openLoginViewController()
    }
    
    private func openLoginViewController() {
        // FirebaseAuth
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginViewController, animated: true)
                return
            }
        } catch let error {
            print("*** Failed to sign out with error: \(error) ***")
        }
        
        // Facebook
//        if AccessToken.isCurrentAccessTokenActive == false {
//            print("The user is logged in")
//
//            DispatchQueue.main.async {
//                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                self.present(loginViewController, animated: true)
//                return
//            }
//        }
    }
    
    private func openMainViewController() {
    dismiss(animated: true)
    }
    
    private func fetchFacebookFields() {
        
    }
}
