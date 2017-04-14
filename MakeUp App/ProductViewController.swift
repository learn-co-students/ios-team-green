//  ProductViewController.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, CircularButtonDelegate {
    
    let resultStore = ResultStore.sharedInstance
    
    var product: Product?
    
    let bottomBar = BottomBarView()
    let productImage = UIImageView()
    
    let tutorialsButton = CircularButton(image: #imageLiteral(resourceName: "Cosmetic Brush_100"), title: "Tutorials", size: 100)
    let reviewsButton = CircularButton(image: #imageLiteral(resourceName: "Lip Gloss_100"), title: "Reviews", size: 100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.white.color
        
        guard let product = resultStore.product else { return }
        
        navBar(title: truncateStringAfterNumberofWords(string: product.title, words: 3), leftButton: determineFavoriteButton(), rightButton: .buy)
        BottomBarView.constrainBottomBarToEdges(viewController: self, bottomBar: bottomBar)

        
        ImageAPIClient.getProductImage(with: product.imageURL) { (productImage) in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, animations: {
                    self.productImage.image = productImage
                })
            }
        }
        setUpLabels()
    }
    
    // Circular Button Delegate Method
    
    func buttonTapped(sender: CircularButton) {
        switch sender.title {
        case "Tutorials":
            if let product = resultStore.product {
                self.resultStore.getYouTubeVideos(search: product.title, videoType: .tutorial) {
                    DispatchQueue.main.async {
                        let TutorialsVC = YouTubeViewController()
                        TutorialsVC.type = "Tutorials"
                        self.navigationController?.pushViewController(TutorialsVC, animated: true)
                    }
                }
            }
        default:
            if let product = resultStore.product {
                self.resultStore.getYouTubeVideos(search: product.title, videoType: .review) {
                    DispatchQueue.main.async {
                        let ReviewsVC = YouTubeViewController()
                        ReviewsVC.type = "Reviews"
                        self.navigationController?.pushViewController(ReviewsVC, animated: true)
                    }
                }
            }
            
        }
    }
    
    func setUpLabels() {
        
        view.addSubview(productImage)
        
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        productImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        productImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        productImage.contentMode = UIViewContentMode.scaleAspectFit
        
        let buttons = [tutorialsButton, reviewsButton]
        
        buttons.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
            $0.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 20).isActive = true
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
    
    
    
    
}
