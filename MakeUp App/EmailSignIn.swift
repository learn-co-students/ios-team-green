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
        emailField.setLeftPaddingPoints(5)
        emailField.setRightPaddingPoints(5)
        passwordField.setLeftPaddingPoints(5)
        passwordField.setRightPaddingPoints(5)
        
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
        let components = [emailField, passwordField, goButton, textLabel]
        components.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            $0.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
        
        resetTextView.translatesAutoresizingMaskIntoConstraints = false
        
        emailField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        passwordField.isSecureTextEntry = true
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 35).isActive = true
        goButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 35).isActive = true
        
        goButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
        textLabel.topAnchor.constraint(equalTo: goButton.bottomAnchor, constant: 40).isActive = true
        
        view.addSubview(resetTextView)
        resetTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        resetTextView.topAnchor.constraint(equalTo: goButton.bottomAnchor, constant: 5).isActive = true
        resetTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        setResetLink()
    }
    
    func resetPassword(_ sender: UITapGestureRecognizer) {
        navigationController?.pushViewController(ResetPasswordViewController(), animated: true)
    }
    
    func dismissVC() {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func submit() {
        
        if emailField.text == "" && passwordField.text == "" {
            UIView.animate(withDuration: 0.2, animations: {
                let alertController = UIAlertController(title: "Uh Oh!", message: "Please enter your email and password", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Got it!", style: .default, handler: { (action) in
                    alertController.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            })
            return}
        else if emailField.text == "" {
            UIView.animate(withDuration: 0.2, animations: {
                let alertController = UIAlertController(title: "Uh Oh!", message: "Please enter your email", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Got it!", style: .default, handler: { (action) in
                    alertController.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            })
            return}
        else if passwordField.text == "" {
            UIView.animate(withDuration: 0.2, animations: {
                let alertController = UIAlertController(title: "Uh Oh!", message: "Please enter your password", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Got it!", style: .default, handler: { (action) in
                    alertController.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            })
            return}
        
        guard (emailField.text != "") && (passwordField.text != "") else { print("returning email password"); return }
        FirebaseManager.shared.signInUser(email: emailField.text!, password: passwordField.text!) { (error) in
            if error != nil {
                //fatalError(error!.localizedDescription)
                print("**SignIn failed. error: \(error!) \n**error.debugDescription: \(error.debugDescription)" )
                //print("**error appEventParameterValue: \(error!._code.appEventParameterValue) NSError: \(NSError.userInfoValueProvider(forDomain: "FIRAuthErrorDomain"))")
                UIView.animate(withDuration: 0.2, animations: {
                    let alertController = UIAlertController(title: "Uh Oh!", message: "Seems like you've entered an incorrect email or password", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Got it!", style: .default, handler: { (action) in
                        alertController.dismiss(animated: true, completion: nil)
                    })
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                })
                return}
            else {
                print("In submit:signInUser")
                let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                self.present(pageViewController, animated: true, completion: nil)
                
            }
            
        } //SignInUser
    }
    
}
