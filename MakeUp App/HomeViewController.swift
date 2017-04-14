//
//  HomeViewController.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/5/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    var myProducts = MediaCollectionView(frame: CGRect.zero)
    var myProductsSearch = UITextField()
    var horizontalRuleMyProducts = HorizontalRule()
    var bottomBar = BottomBarView()
    
    var allProducts = [Product]()
    var displayProducts = [Product]() {
        didSet {
            displayProducts.sort { $0.0.title < $0.1.title }
        }
    }

    var myMedia = MediaCollectionView(frame: CGRect.zero)
    var myMediaSearch = UITextField()
    var horizontalRuleMyMedia = HorizontalRule()
    
    var allMedia = [Youtube]()
    var displayMedia = [Youtube]() {
        didSet {
            displayMedia.sort { $0.0.title < $0.1.title }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.white.color
        guard let username = FirebaseManager.shared.currentUser?.displayName else { print("loaded home view controller but dang, there's no username"); return }
        navBar(title: username, leftButton: nil, rightButton: nil)
        setupLabels()
        setupCollectionViews()
        BottomBarView.constrainBottomBarToEdges(viewController: self, bottomBar: bottomBar)
        databaseMethods()
    
    }
    
  
    
    
    //MARK: - UI SetUp
    func setupLabels() {
        
        myProductsSearch.delegate = self
        myMediaSearch.delegate = self
        
        view.addSubview(myProductsSearch)
        view.addSubview(horizontalRuleMyProducts)
        view.addSubview(myProducts)
        
        view.addSubview(myMediaSearch)
        view.addSubview(horizontalRuleMyMedia)
        view.addSubview(myMedia)

        
        myProductsSearch.attributedPlaceholder = NSAttributedString(string: "My Products", attributes: [NSForegroundColorAttributeName: Palette.darkGrey.color])
        myProductsSearch.textColor = Palette.darkGrey.color
        myProductsSearch.backgroundColor = Palette.white.color
        myProductsSearch.font = Fonts.Playfair(withStyle: .italic, sizeLiteral: 30)
        
        myProductsSearch.translatesAutoresizingMaskIntoConstraints = false
        myProductsSearch.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        myProductsSearch.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        myProductsSearch.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        myProductsSearch.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        horizontalRuleMyProducts.translatesAutoresizingMaskIntoConstraints = false
        horizontalRuleMyProducts.topAnchor.constraint(equalTo: myProductsSearch.bottomAnchor).isActive = true
        horizontalRuleMyProducts.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        horizontalRuleMyProducts.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // MY MEDIA
        myMediaSearch.attributedPlaceholder = NSAttributedString(string: "My Media", attributes: [NSForegroundColorAttributeName: Palette.darkGrey.color])
        myMediaSearch.textColor = Palette.darkGrey.color
        myMediaSearch.backgroundColor = Palette.white.color
        myMediaSearch.font = Fonts.Playfair(withStyle: .italic, sizeLiteral: 30)
        
        myMediaSearch.translatesAutoresizingMaskIntoConstraints = false
        myMediaSearch.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        myMediaSearch.topAnchor.constraint(equalTo: myProducts.bottomAnchor).isActive = true
        myMediaSearch.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        
        horizontalRuleMyMedia.translatesAutoresizingMaskIntoConstraints = false
        horizontalRuleMyMedia.topAnchor.constraint(equalTo: myMediaSearch.bottomAnchor).isActive = true
        horizontalRuleMyMedia.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        horizontalRuleMyMedia.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func setupCollectionViews() {
        
        myProducts.register(ProductViewCell.self, forCellWithReuseIdentifier: "productCell")
        myMedia.register(MediaViewCell.self, forCellWithReuseIdentifier: "mediaCell")
        
        myProducts.translatesAutoresizingMaskIntoConstraints = false
        myProducts.dataSource = self
        myProducts.delegate = self
        
        myMedia.translatesAutoresizingMaskIntoConstraints = false
        myMedia.dataSource = self
        myMedia.delegate = self
        
        myProducts.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        myProducts.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        myProducts.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myProducts.topAnchor.constraint(equalTo: horizontalRuleMyProducts.bottomAnchor, constant: 15).isActive = true
        
        myMedia.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        myMedia.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        myMedia.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myMedia.topAnchor.constraint(equalTo: myMediaSearch.bottomAnchor, constant: 15).isActive = true
        
    }
    

    // MARK: - Search Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // If you touch outside of a text field, it ends ending
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var currentSearch = textField.text! as NSString
        currentSearch = currentSearch.replacingCharacters(in: range, with: string) as NSString
        switch textField {
        case self.myProductsSearch:
            if currentSearch as String != "" {
                displayProducts.removeAll()
                allProducts.forEach {
                    if $0.title.localizedCaseInsensitiveContains(currentSearch as String) {
                        displayProducts.append($0)
                    }
                }
            } else {
                displayProducts = allProducts
            }
            myProducts.reloadData()
            
        default:
            if currentSearch as String != "" {
                displayMedia.removeAll()
                allMedia.forEach {
                    if $0.title.localizedCaseInsensitiveContains(currentSearch as String) {
                        displayMedia.append($0)
                    }
                }
            } else {
                displayMedia = allMedia
            }
            myMedia.reloadData()
        }
        return true
    }
    
    
    // MARK: - Collectionview Methods
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.2) {
            cell.alpha = 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.myProducts {
            let cell = collectionView.cellForItem(at: indexPath) as! ProductViewCell
            ResultStore.sharedInstance.product = cell.product
            self.navigationController?.pushViewController(ResultsViewController(), animated: true)
        } else {
            let destinationVC = YouTubePlayerViewViewController()
            let cell = displayMedia[indexPath.item]
            destinationVC.youtubeID = cell.videoID
            destinationVC.modalPresentationStyle = .overCurrentContext
            destinationVC.modalTransitionStyle = .crossDissolve
            present(destinationVC, animated: true, completion: nil )
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.myProducts {
            return displayProducts.count
        } else {
            return displayMedia.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == self.myProducts {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath as IndexPath) as! ProductViewCell
            cell.product = displayProducts[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath as IndexPath) as! MediaViewCell
            cell.youtube = displayMedia[indexPath.item]
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: collectionView.frame.height)
    }
    
    // MARK: - Database Methods
    
    func databaseMethods() {
        FirebaseManager.shared.fetchUserProducts { (products) in
            self.allProducts.removeAll()
            self.allProducts = products
            self.displayProducts = products
            //  also save in user store for local checking against other products ...
            UserStore.sharedInstance.favoriteProducts = products
            self.myProducts.reloadData()
            
        }
        FirebaseManager.shared.fetchUserMedia { (media) in
            self.allMedia.removeAll()
            self.allMedia = media
            self.displayMedia = media
            //  also save in user store for local checking against other media ...
            UserStore.sharedInstance.favoriteMedia = media
            self.myMedia.reloadData()
        }
    }
    

    
    
}
