//
//  ResetPassword.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation

import UIKit

class ResetPasswordViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "   Email"
        field.textAlignment = .left
        field.textColor = Palette.white.color
        field.backgroundColor = Palette.beige.color
        field.font = Fonts.Playfair(withStyle: .black, sizeLiteral: 16)
        return field
    }()

    
    let goButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send Reset Link", for: .normal)
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Palette.white.color
        emailField.setLeftPaddingPoints(10)
        emailField.setRightPaddingPoints(10)
       
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissVC))
        setupComponents()
    }


    
    func setupComponents() {
        let components = [ emailField, goButton, textLabel ]
        components.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            $0.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
        
        emailField.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        goButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 40).isActive = true
        
        goButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
        textLabel.topAnchor.constraint(equalTo: goButton.bottomAnchor, constant: 40).isActive = true
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailField.endEditing(true)
    }
    
    func dismissVC() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func submit() {
        guard (emailField.text != nil) else { return }
        FirebaseManager.shared.resetPassword(email: emailField.text!) { (error) in
            if error != nil {
                //fatalError(error!.localizedDescription)
                print("ResetPassword failed: \(error.debugDescription)" )
                self.textLabel.text = error!.localizedDescription
            } else {
                self.textLabel.text = "Reset Email Sent."
            }
            
        } //shared.resetPassword
    }

}
