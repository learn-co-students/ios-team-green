//
//  EmailSignIn.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation

import UIKit

class EmailSignInViewController: UIViewController, UIGestureRecognizerDelegate {

    let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "   Email"
        field.textAlignment = .left
        field.textColor = Palette.white.color
        field.backgroundColor = Palette.beige.color
        field.font = Fonts.Playfair(withStyle: .black, sizeLiteral: 16)
        return field
    }()
    
    let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "   Password"
        field.textAlignment = .left
        field.textColor = Palette.white.color
        field.backgroundColor = Palette.beige.color
        field.font = Fonts.Playfair(withStyle: .black, sizeLiteral: 16)
        return field
    }()

    
    let goButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = Fonts.Playfair(withStyle: .black, sizeLiteral: 16)
        button.backgroundColor = Palette.beige.color
        return button
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = Palette.black.color
        label.numberOfLines = 4
        label.font = Fonts.Playfair(withStyle: .black, sizeLiteral: 16)
        return label
    }()

    var resetTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Palette.white.color
        emailField.setLeftPaddingPoints(10)
        emailField.setRightPaddingPoints(10)
        passwordField.setLeftPaddingPoints(10)
        passwordField.setRightPaddingPoints(10)
        passwordField.isSecureTextEntry = true
        emailField.autocapitalizationType = UITextAutocapitalizationType.none
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissVC))
        setupComponents()
    }

    func setResetLink() {
        
        let resetStr = NSMutableAttributedString(string: "Forgot your password? Reset password!")
        
        resetStr.addAttribute(NSFontAttributeName, value: Fonts.Playfair(withStyle: .italic, sizeLiteral: 16), range: NSMakeRange(0, 21))
        resetStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: NSMakeRange(22, 15))
        resetTextView.attributedText = resetStr
        let tap = UITapGestureRecognizer(target: self, action: #selector(resetPassword(_ :)))
        tap.delegate = self
        resetTextView.addGestureRecognizer(tap)
    }

    
    func setupComponents() {
        let components = [emailField, passwordField, goButton, textLabel, resetTextView]
        components.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            $0.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
        
        emailField.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 40).isActive = true
        goButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 40).isActive = true
        
        goButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
        textLabel.topAnchor.constraint(equalTo: goButton.bottomAnchor, constant: 40).isActive = true
        
        resetTextView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 20).isActive = true
        
    }
    
    func resetPassword(_ sender: UITapGestureRecognizer) {
        navigationController?.pushViewController(ResetPasswordViewController(), animated: true)
    }
    
    func dismissVC() {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailField.endEditing(true)
        passwordField.endEditing(true)
    }
    
    func submit() {
        guard (emailField.text != nil) && (passwordField.text != nil) else { return }
        FirebaseManager.shared.signInUser(email: emailField.text!, password: passwordField.text!) { (error) in
            if error != nil {
                //fatalError(error!.localizedDescription)
                print("**SignIn failed. error: \(error!) \n**error.debugDescription: \(error.debugDescription)" )
                //print("**error appEventParameterValue: \(error!._code.appEventParameterValue) NSError: \(NSError.userInfoValueProvider(forDomain: "FIRAuthErrorDomain"))")
                
                self.textLabel.text = error!.localizedDescription
                
                self.setResetLink()
                
            } else {
                print("In submit:signInUser")
                let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                self.present(pageViewController, animated: true, completion: nil)
                
            }
            
        } //SignInUser
    }

}
