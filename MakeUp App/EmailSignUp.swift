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
        guard (emailField.text != nil) && (nameField.text != nil) && (passwordField.text != nil) else { return }
        //present tabbarcontroller ...
        print("submitted sign in button")
        let tabBarController = TabBarController()
        self.navigationController?.present(tabBarController, animated: true, completion: nil)
    }

}
