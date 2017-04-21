//
//  SignUpViewController.swift
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

class SignUpViewController: UIViewController, UIGestureRecognizerDelegate {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Voilá"
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
    
    var textView = UITextView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setSignUpLink()
        setupComponents()

        
    }
    
    func setSignUpLink() {
        
        let signUpStr = NSMutableAttributedString(string: "Don't have an account? Sign Up!")
        
        signUpStr.addAttribute(NSFontAttributeName, value: Fonts.Playfair(withStyle: .italic, sizeLiteral: 16), range: NSMakeRange(0, 31))
        signUpStr.addAttributes([NSForegroundColorAttributeName: Palette.beige.color, NSFontAttributeName: Fonts.Playfair(withStyle: .blackItalic, sizeLiteral: 16)], range: NSMakeRange(23, 8))
        textView.attributedText = signUpStr
        let tap = UITapGestureRecognizer(target: self, action: #selector(signUpUser(_ :)))
        tap.delegate = self
        textView.addGestureRecognizer(tap)
    }
    
    
    func setupComponents() {
        let components = [/*googleButton,*/ facebookButtton, emailButton, titleLabel, textView]
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
        
        facebookButtton.centerYAnchor.constraint(equalTo: emailButton.centerYAnchor, constant: -80).isActive = true
        facebookButtton.addTarget(self, action: #selector(facebookLogin(_:didCompleteWith:error:)), for: .touchUpInside)
        
        /*googleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        googleButton.addTarget(self, action: #selector(googleSignUp), for: .touchUpInside)*/
        
        emailButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        emailButton.addTarget(self, action: #selector(emailSignIn), for: .touchUpInside)

        textView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textView.textAlignment = .center

        titleLabel.bottomAnchor.constraint(equalTo: facebookButtton.topAnchor, constant: -40).isActive = true
        
    }

    func googleSignUp() {
        print("TODO: FIREBASE google sign up")
    }
        
    //Email signIn
    func emailSignIn() {
        let emailSignInViewController = EmailSignInViewController()
        self.navigationController?.pushViewController(emailSignInViewController, animated: true)
    }

    func signUpUser(_ sender: UITapGestureRecognizer) {
        let emailSignUpViewController = EmailUpViewController()
        self.navigationController?.pushViewController(emailSignUpViewController, animated: true)
    }
    
}

private typealias FacebookLoginManager = SignUpViewController
extension FacebookLoginManager {
    
    func validateLogin() {
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if let validationError = error {
                print("Validate Login -> error validating login: %@", validationError)
            } else if let user = user {
                UserDefaults.standard.set(user.uid, forKey: "userID")
                FirebaseManager.shared.createOrUpdate(user)
                FirebaseManager.shared.loginType = "facebook"
                // go to Home View
                let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                self.present(pageViewController, animated: true, completion: nil)
            } else {
                print("LoginVC -> error validating login")
            }
        }
    }
    
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
            self.validateLogin()
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

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
