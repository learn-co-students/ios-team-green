//
//  ViewController.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookLogin
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Contour"
        label.textColor = Palette.darkGrey.color
        label.font = Fonts.Playfair(withStyle: .italic, sizeLiteral: 60)
        label.textAlignment = .center
        
        return label
    }()
    
    let googleButton: UIButton = {
        return SignInButton(image: #imageLiteral(resourceName: "Google"), text: "\tGoogle Sign In")
    }()
    
    let facebookButtton: UIButton = {
        return SignInButton(image: #imageLiteral(resourceName: "Facebook"), text: "\tFacebook Sign In")
        
    }()
    
    let emailButton: UIButton = {
        return SignInButton(image: #imageLiteral(resourceName: "Message"), text: "\tEmail Sign In")
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupComponents()
    }
    
    func setupComponents() {
        let components = [googleButton, facebookButtton, emailButton, titleLabel]
        components.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
            $0.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 60).isActive = true
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
        setupUniqueConstraints()
    }
    
    func setupUniqueConstraints() {
        
        facebookButtton.centerYAnchor.constraint(equalTo: googleButton.centerYAnchor, constant: -80).isActive = true
        facebookButtton.addTarget(self, action: #selector(facebookLogin(_:didCompleteWith:error:)), for: .touchUpInside)
        
        googleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        googleButton.addTarget(self, action: #selector(googleSignUp), for: .touchUpInside)
        
        emailButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
        emailButton.addTarget(self, action: #selector(emailSignUp), for: .touchUpInside)
        
        titleLabel.bottomAnchor.constraint(equalTo: facebookButtton.topAnchor, constant: -40).isActive = true
        
    }

    func googleSignUp() {
        print("TODO: FIREBASE google sign up")
    }
    
    func emailSignUp() {
        print("TODO: email sign up")
        let emailSignUpViewController = EmailUpViewController()
        self.navigationController?.pushViewController(emailSignUpViewController, animated: true)
    }
    
}

private typealias FacebookLoginManager = SignUpViewController
extension FacebookLoginManager {
    
    func facebookLogin(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
        if error != nil {
            print("Facebook error -> while logging in")
        }
        else if (result?.isCancelled)! {
            print("Facebook sign in -> user cancelled login")
        }
        else {
            print("Facebook -> user logged in")
            validateLogin()
        }
    }
    
    func validateLogin() {
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if let validationError = error {
                print("Validate Login -> error validating login: %@", validationError)
            } else if let user = user {
                UserDefaults.standard.set(user.uid, forKey: "userID")
                FirebaseManager.shared.createOrUpdate(user)

                // go to Home View
                self.present(TabBarController(), animated: true, completion: nil)
            } else {
                print("LoginVC -> error validating login")
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        do {
            try FIRAuth.auth()?.signOut()
            print("LoginVC -> user logged out")
        } catch let signOutError as NSError {
            print ("LoginVC -> error while signing out: %@", signOutError)
        }
    }
}

}
