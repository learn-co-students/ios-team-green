//  ProductViewController.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    let resultStore = ResultStore.sharedInstance

    // CURRENTLY UNUSED
    //let productDisplay = ProductDisplayView()
    
    let productImage = UIImageView()
    
    let tutorialsButton = CircularView(image: #imageLiteral(resourceName: "Cosmetic Brush_100"), text: "Tutorials")
    let reviewsButton = CircularView(image: #imageLiteral(resourceName: "Lip Gloss_100"), text: "Reviews")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.white.color
        
        guard let product = resultStore.product else { return }

        navBar(title: truncateStringAfterNumberofWords(string: product.title, words: 3), leftButton: .favorite, rightButton: .buy)
        
        ImageAPIClient.getProductImage(with: product.imageURL) { (productImage) in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, animations: {
                    self.productImage.image = productImage
                })
            }
        }

        setUpLabels()

    }

    func setUpLabels() {

        view.addSubview(productImage)

        productImage.translatesAutoresizingMaskIntoConstraints = false
        productImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        productImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        productImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        productImage.contentMode = UIViewContentMode.scaleAspectFit
        
        let buttons = [tutorialsButton, reviewsButton]
        
        buttons.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
            $0.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 20).isActive = true
            
        }
        
        tutorialsButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -20).isActive = true

        reviewsButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 20).isActive = true

        
    }
    

    
    
}
