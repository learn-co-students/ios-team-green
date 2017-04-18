//
//  SearchTableViewController.swift
//  MakeUp App
//
//  Created by amit chadha on 4/10/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit
import Firebase

class SearchTableViewController: UITableViewController {

    var ref: FIRDatabaseReference!
    var productArray = [Product]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        navBar(title: "Search Results", leftButton: .backToSearch, rightButton: nil)
       
        tableView.register(ProductCell.self, forCellReuseIdentifier: "myProductCell")
        
        let searchString = UserStore.sharedInstance.searchQuery
            ProductAPIClient().stringSearch(searchString: searchString) { (products) in
                DispatchQueue.main.async {
                    self.productArray = products
                    self.tableView.reloadData()
                }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.popViewController(animated: true)
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myProductCell", for: indexPath) as! ProductCell
        cell.product = productArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addToDB(productArray[indexPath.row])
        NotificationCenter.default.post(name: .productVC, object: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func addToDB(_ product: Product) {
        let itemRef = self.ref.child(product.upc)
        itemRef.setValue(product.toDict())
    }
    


}
