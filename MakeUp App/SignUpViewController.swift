//
//  ViewController.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit

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
        return SignInButton(image: #imageLiteral(resourceName: "Google"), text: "   Google Sign In")
    }()
    
    let facebookButtton: UIButton = {
       return SignInButton(image: #imageLiteral(resourceName: "Facebook"), text: "  Facebook Sign In")
   
    }()
    
    let emailButton: UIButton = {
        return SignInButton(image: #imageLiteral(resourceName: "Message"), text: "   Email Sign In")
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
        present(ResultsViewController(), animated: true, completion: nil)
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
        facebookButtton.addTarget(self, action: #selector(facebookSignUp), for: .touchUpInside)
        
        googleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        googleButton.addTarget(self, action: #selector(googleSignUp), for: .touchUpInside)
 
        emailButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
        emailButton.addTarget(self, action: #selector(emailSignUp), for: .touchUpInside)
        
        titleLabel.bottomAnchor.constraint(equalTo: facebookButtton.topAnchor, constant: -40).isActive = true
    
    }
    
    func facebookSignUp() {
        print("+++ FIREBASE facebook sign up")
    }
    
    func googleSignUp() {
        print("+++ FIREBASE google sign up")
    }
    
    func emailSignUp() {
        print("+++ email sign up")
        let emailSignUpViewController = EmailUpViewController()
        self.navigationController?.pushViewController(emailSignUpViewController, animated: true)  
    }


}

