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
    
    var allProducts = UserData.shared.dataStore.myProducts
    var displayProducts = [Product]()
    
    var myMediaLabel = UILabel()
    var myMedia = MediaCollectionView(frame: CGRect.zero)
    var myMediaSearch = UITextField()
    
    var allMedia = UserData.shared.dataStore.myMedia
    var displayMedia = [MediaItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayProducts = allProducts
        displayMedia = allMedia
        
        view.backgroundColor = Palette.white.color
        
        navBar(title: "Raquel Rahmey", leftButton: nil, rightButton: nil)
        setupLabels()
        setupCollectionViews()
    }
    
    //MARK: - UI SetUp
    
    func setupLabels() {
        
        myProductsSearch.delegate = self
        myMediaSearch.delegate = self
        
        view.addSubview(myMediaLabel)
        view.addSubview(myProductsLabel)
        view.addSubview(myProducts)
        view.addSubview(myMedia)
        view.addSubview(myProductsSearch)
        view.addSubview(myMediaSearch)
        
        myProductsLabel.text = "My Products"
        myProductsLabel.textColor = Palette.darkGrey.color
        myProductsLabel.font = Fonts.Playfair(withStyle: .italic, sizeLiteral: 30)
        myProductsLabel.textAlignment = .left
        
        myProductsLabel.translatesAutoresizingMaskIntoConstraints = false
        myProductsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        myProductsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        myProductsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        myProductsLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        
        myProductsSearch.placeholder = "Search..."
        myProductsSearch.backgroundColor = Palette.white.color
        myProductsSearch.font = Fonts.Playfair(withStyle: .italic, sizeLiteral: 16)
        
        myProductsSearch.translatesAutoresizingMaskIntoConstraints = false
        myProductsSearch.leftAnchor.constraint(equalTo: myProductsLabel.rightAnchor, constant: 10).isActive = true
        myProductsSearch.topAnchor.constraint(equalTo: myProductsLabel.topAnchor).isActive = true
        myProductsSearch.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        myProductsSearch.heightAnchor.constraint(equalTo: myProductsLabel.heightAnchor).isActive = true
        
        myMediaLabel.text = "My Media"
        myMediaLabel.textColor = Palette.darkGrey.color
        myMediaLabel.font = Fonts.Playfair(withStyle: .italic, sizeLiteral: 30)
        myMediaLabel.textAlignment = .left
        
        myMediaLabel.translatesAutoresizingMaskIntoConstraints = false
        myMediaLabel.topAnchor.constraint(equalTo: myProducts.bottomAnchor).isActive = true
        myMediaLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        myMediaLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        myMediaLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        
        myMediaSearch.placeholder = "Search..."
        myMediaSearch.backgroundColor = Palette.white.color
        myMediaSearch.font = Fonts.Playfair(withStyle: .italic, sizeLiteral: 16)
        
        myMediaSearch.translatesAutoresizingMaskIntoConstraints = false
        myMediaSearch.leftAnchor.constraint(equalTo: myMediaLabel.rightAnchor, constant: 10).isActive = true
        myMediaSearch.topAnchor.constraint(equalTo: myMediaLabel.topAnchor).isActive = true
        myMediaSearch.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        myMediaSearch.heightAnchor.constraint(equalTo: myMediaLabel.heightAnchor).isActive = true
        
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
        myProducts.topAnchor.constraint(equalTo: myProductsLabel.bottomAnchor).isActive = true
        
        myMedia.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        myMedia.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        myMedia.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myMedia.topAnchor.constraint(equalTo: myMediaLabel.bottomAnchor).isActive = true
        
    }
    
    // MARK: - Search Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var currentSearch = textField.text! as NSString
        currentSearch = currentSearch.replacingCharacters(in: range, with: string) as NSString
        
        switch textField {
        case self.myProductsSearch:
            if currentSearch as String != "" {
                displayProducts.removeAll()
                allProducts.forEach {
                    if $0.title.contains(currentSearch as String) {
                        displayProducts.append($0)
                    }
                }
            } else {
                displayProducts = allProducts
            }
            myProducts.reloadData()
            
        default:
            print("hello")
            if currentSearch as String != "" {
                displayMedia.removeAll()
                displayMedia.forEach {
                    if $0.title.contains(currentSearch as String) {
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
        UIView.animate(withDuration: 0.3) {
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
            cell.mediaItem = displayMedia[indexPath.item]
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: collectionView.frame.height)
    }
    
    
}
