//  ProductViewController.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, CircularButtonDelegate {
    
    let resultStore = ResultStore.sharedInstance
    
    var product: Product? {
        didSet {
            setUpProduct()
        }
    }
    let productImage = UIImageView()
    let titleLabel = UILabel()
    
    let tutorialsButton = CircularButton(image: #imageLiteral(resourceName: "Cosmetic Brush_100"), title: "Tutorials", size: 100)
    let reviewsButton = CircularButton(image: #imageLiteral(resourceName: "Lip Gloss_100"), title: "Reviews", size: 100)
    let searchButton = CircularButton(image: #imageLiteral(resourceName: "Search"), title: "Get Started!", size: 100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.white.color
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.post(name: .productVC, object: nil)
        self.product = resultStore.product
        if product == nil {
            setUpNoProduct()
        } else {
            searchButton.alpha = 0
            setUpProduct()
        }
    }
    
    func setUpNoProduct() {
        navBar(title: "Nothing Here Yet!", leftButton: nil, rightButton: nil)
        setUpLabels()
        productImage.image = #imageLiteral(resourceName: "Placeholder")
        
        view.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchButton.heightAnchor.constraint(equalTo: searchButton.widthAnchor).isActive = true
        searchButton.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 30).isActive = true
        searchButton.delegate = self
        
    }
    
    func setUpProduct() {
        guard let product = resultStore.product else { return }
        navBar(title: truncateStringAfterNumberofWords(string: product.brand, words: 3), leftButton: determineFavoriteButton(), rightButton: .buy)
        ImageAPIClient.getProductImage(with: product.imageURL) { (productImage) in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, animations: {
                    self.productImage.image = productImage
                })
            }
        }
        setUpLabels()
        setUpButtons()
    }
    
    func setUpLabels() {
        
        view.addSubview(productImage)
        view.addSubview(titleLabel)
        
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        productImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        productImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        productImage.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.9).isActive = true
        productImage.contentMode = UIViewContentMode.scaleAspectFit
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: productImage.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        if let product = resultStore.product  {
            titleLabel.text = product.title + "\n$" + String(product.price)
        }
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.Playfair(withStyle: .italic, sizeLiteral: 20)
        titleLabel.numberOfLines = 0
        
    }
    
    func setUpButtons() {
        let buttons = [tutorialsButton, reviewsButton]
        buttons.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
            $0.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
            $0.delegate = self
        }
        
        tutorialsButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -20).isActive = true
        reviewsButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 20).isActive = true
        
    }
    
    func determineFavoriteButton() -> ButtonType {
        
        let isFavorite = UserStore.sharedInstance.favoriteProducts.contains(where: { (diffProduct) -> Bool in
            guard let product = resultStore.product else { return false }
            return product.title == diffProduct.title
        })
        
        if isFavorite {
            return ButtonType.favorite
        } else {
            return ButtonType.notFavorite
        }
    }
    
    // Circular Button Delegate Method
    func buttonTapped(sender: CircularButton) {
        switch sender.title {
        case "Tutorials":
            NotificationCenter.default.post(name: .tutorialsVC, object: nil)
        case "Get Started!":
            NotificationCenter.default.post(name: .searchVC, object: nil)
        default:
            NotificationCenter.default.post(name: .reviewsVC, object: nil)
        }
    }
    
    
    
    
    
    
}
