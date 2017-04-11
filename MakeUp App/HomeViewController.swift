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
    
    var myProductsLabel = UILabel()
    var myProducts = MediaCollectionView(frame: CGRect.zero)
    var myProductsSearch = UITextField()
    var horizontalRuleMyProducts = HorizontalRule()
    
    var allProducts = UserStore.sharedInstance.myProducts
    var displayProducts = [Product]()
    
    var myMediaLabel = UILabel()
    var myMedia = MediaCollectionView(frame: CGRect.zero)
    var myMediaSearch = UITextField()
    var horizontalRuleMyMedia = HorizontalRule()
    
    var allMedia = UserStore.sharedInstance.myMedia
    var displayMedia = [Youtube]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FirebaseManager.shared.fetchUserFavorites { (products) in
            
            // Hm, this could be simpler
            UserStore.sharedInstance.myProducts.removeAll()
            UserStore.sharedInstance.myProducts = products
            self.allProducts = UserStore.sharedInstance.myProducts
            self.displayProducts = self.allProducts
            self.myProducts.reloadData()
            print("line 39")
            
        }
        view.backgroundColor = Palette.white.color
        guard let username = FirebaseManager.shared.currentUser?.displayName else { print("loaded home view controller but dang, there's no username"); return }
        navBar(title: username, leftButton: nil, rightButton: nil)
        setupLabels()
        setupCollectionViews()
    }
    
    
    //MARK: - UI SetUp
    
    func setupLabels() {
        
        myProductsSearch.delegate = self
        myMediaSearch.delegate = self
        
        view.addSubview(myProductsLabel)
        view.addSubview(myProductsSearch)
        view.addSubview(horizontalRuleMyProducts)
        view.addSubview(myProducts)
        
        view.addSubview(myMediaLabel)
        view.addSubview(myMediaSearch)
        view.addSubview(horizontalRuleMyMedia)
        view.addSubview(myMedia)
        
        myProductsLabel.text = "My Products"
        myProductsLabel.textColor = Palette.darkGrey.color
        myProductsLabel.font = Fonts.Playfair(withStyle: .italic, sizeLiteral: 30)
        myProductsLabel.textAlignment = .left
        
        myProductsLabel.translatesAutoresizingMaskIntoConstraints = false
        myProductsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        myProductsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        myProductsLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        
        myProductsSearch.placeholder = "Search..."
        myProductsSearch.backgroundColor = Palette.white.color
        myProductsSearch.font = Fonts.Playfair(withStyle: .italic, sizeLiteral: 16)
        
        myProductsSearch.translatesAutoresizingMaskIntoConstraints = false
        myProductsSearch.leftAnchor.constraint(equalTo: myProductsLabel.rightAnchor, constant: 15).isActive = true
        myProductsSearch.centerYAnchor.constraint(equalTo: myProductsLabel.centerYAnchor, constant: 5).isActive = true
        myProductsSearch.heightAnchor.constraint(equalTo: myProductsLabel.heightAnchor).isActive = true
        myProductsSearch.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        
        horizontalRuleMyProducts.translatesAutoresizingMaskIntoConstraints = false
        horizontalRuleMyProducts.topAnchor.constraint(equalTo: myProductsLabel.bottomAnchor).isActive = true
        horizontalRuleMyProducts.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        horizontalRuleMyProducts.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // MY MEDIA
        
        myMediaLabel.text = "My Media"
        myMediaLabel.textColor = Palette.darkGrey.color
        myMediaLabel.font = Fonts.Playfair(withStyle: .italic, sizeLiteral: 30)
        
        myMediaLabel.translatesAutoresizingMaskIntoConstraints = false
        myMediaLabel.topAnchor.constraint(equalTo: myProducts.bottomAnchor).isActive = true
        myMediaLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        myMediaLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        
        myMediaSearch.placeholder = "Search..."
        myMediaSearch.backgroundColor = Palette.white.color
        myMediaSearch.font = Fonts.Playfair(withStyle: .italic, sizeLiteral: 16)
        
        myMediaSearch.translatesAutoresizingMaskIntoConstraints = false
        myMediaSearch.leftAnchor.constraint(equalTo: myMediaLabel.rightAnchor, constant: 15).isActive = true
        myMediaSearch.topAnchor.constraint(equalTo: myMediaLabel.topAnchor).isActive = true
        myMediaSearch.heightAnchor.constraint(equalTo: myMediaLabel.heightAnchor).isActive = true
        
        horizontalRuleMyMedia.translatesAutoresizingMaskIntoConstraints = false
        horizontalRuleMyMedia.topAnchor.constraint(equalTo: myMediaLabel.bottomAnchor).isActive = true
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
        myMedia.topAnchor.constraint(equalTo: myMediaLabel.bottomAnchor, constant: 15).isActive = true
        
    }
    
    // MARK: - Search Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
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
    
    
}
