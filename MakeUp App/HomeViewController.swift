//
//  HomeViewController.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/5/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var myProductsLabel = UILabel()
    var myProducts = MediaCollectionView(frame: CGRect.zero)
    
    var myMediaLabel = UILabel()
    var myMedia = MediaCollectionView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.white.color
        navBar(title: "Raquel Rahmey", leftButton: nil, rightButton: nil)
        setupLabels()
        setupCollectionViews()
    }
    
    func setupLabels() {
        
        myProductsLabel.text = "My Products"
        myProductsLabel.textColor = Palette.darkGrey.color
        myProductsLabel.font = Fonts.Playfair(withStyle: .italic, sizeLiteral: 30)
        myProductsLabel.textAlignment = .left
        
        myMediaLabel.text = "My Media"
        myMediaLabel.textColor = Palette.darkGrey.color
        myMediaLabel.font = Fonts.Playfair(withStyle: .italic, sizeLiteral: 30)
        myMediaLabel.textAlignment = .left
        
        view.addSubview(myMediaLabel)
        view.addSubview(myProductsLabel)
        view.addSubview(myProducts)
        view.addSubview(myMedia)
        
        myProductsLabel.translatesAutoresizingMaskIntoConstraints = false
        myProductsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        myProductsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        myProductsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        myProductsLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        
        myMediaLabel.translatesAutoresizingMaskIntoConstraints = false
        myMediaLabel.topAnchor.constraint(equalTo: myProducts.bottomAnchor).isActive = true
        myMediaLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        myMediaLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        myMediaLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        
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
    
 //MARK: - COLLECTION VIEW METHODS
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == self.myProducts {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath as IndexPath) as! ProductViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath as IndexPath) as! MediaViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: collectionView.frame.height)
    }


}
