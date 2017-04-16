//
//  EmailSignUp.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

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
        field.placeholder = "   Name"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Palette.white.color

       
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
        
        emailField.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        nameField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 40).isActive = true
        passwordField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 40).isActive = true
        goButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 40).isActive = true
        
        goButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
    }
    
    func dismissVC() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func submit() {
        guard let email = emailField.text, let name = nameField.text, let password = passwordField.text else { return }
        
        if password.characters.count < 6 {
            passwordField.text = "Password too short, try again!"
            return
        }
        
        if !email.contains("@") {
            emailField.text = "Invalid email, try again"
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print("Error with email / password submit:", error as Any)
            } else if let user = user {
                UserDefaults.standard.set(user.uid, forKey: "userID")
                FirebaseManager.shared.createOrUpdate(user)
                let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                self.present(pageViewController, animated: true, completion: nil)
            } else {
                print("EmailSignUpVC -> error validating login")
            }
        })
        
    }

}
