//
//  EmailSignUp.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation

import UIKit

class EmailUpViewController: UIViewController {
    
    
    let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "   Email"
        field.textAlignment = .left
        field.textColor = Palette.white.color
        field.backgroundColor = Palette.beige.color
        field.font = Fonts.Playfair(withStyle: .black, sizeLiteral: 16)
        return field
    }()
    
    let nameField: UITextField = {
        let field = UITextField()
        field.placeholder = "   Full Name"
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
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = Fonts.Playfair(withStyle: .black, sizeLiteral: 16)
        button.backgroundColor = Palette.beige.color
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Palette.white.color
        emailField.setLeftPaddingPoints(5)
        emailField.setRightPaddingPoints(5)
        nameField.setRightPaddingPoints(5)
        nameField.setLeftPaddingPoints(5)
        passwordField.setLeftPaddingPoints(5)
        passwordField.setRightPaddingPoints(5)
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissVC))
        setupComponents()
    }
    
    func setupComponents() {
        let components = [emailField, nameField, passwordField, goButton]
        components.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            $0.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
        
        passwordField.isSecureTextEntry = true
        emailField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        nameField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 30).isActive = true
        passwordField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 30).isActive = true
        goButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30).isActive = true
        
        goButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
        
    }
    
    func dismissVC() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func submit() {
        if nameField.text == "" {
            UIView.animate(withDuration: 0.2, animations: {
                let alertController = UIAlertController(title: "Uh Oh!", message: "Please enter your name", preferredStyle: .alert)
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
            
        else if let passwordCharacters = passwordField.text?.characters{
            if passwordCharacters.count < 6 {
                UIView.animate(withDuration: 0.2, animations: {
                    let alertController = UIAlertController(title: "Uh Oh!", message: "Password must be at least 6 characters long", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Got it!", style: .default, handler: { (action) in
                        alertController.dismiss(animated: true, completion: nil)
                    })
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                })
            }
            return}
        print("got to here")
        guard (emailField.text != nil) && (nameField.text != nil) && (passwordField.text != nil) else { return }
        FirebaseManager.shared.createUser(email: emailField.text!, password: passwordField.text!, name: nameField.text!) { (error) in
            if error != nil {
                //fatalError(error!.localizedDescription)
                print("Failed to create user \(error.debugDescription)")
            } else {
                print("In submit:createUser")
                let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                self.present(pageViewController, animated: true, completion: nil)
                
            }
            
        } //createUser
    }
    
}
