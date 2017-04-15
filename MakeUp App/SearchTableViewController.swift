//
//  SearchTableViewController.swift
//  MakeUp App
//
//  Created by ac on 4/10/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    var searchString:String?
    var productArray:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 80
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        print("In SearchTableViewController:viewWillAppear:searchString:\(String(describing: searchString))")
        
        navBar(title: "Search Results", leftButton: ButtonType(rawValue: "back"), rightButton: nil)
       
        tableView.register(ProductCell.self, forCellReuseIdentifier: "myProductCell")
        
        if let searchStr = searchString {
            ProductAPIClient().stringSearch(searchString: searchStr) { (products) in
                
                DispatchQueue.main.async {
                    
                    self.productArray = products
                    print("In SearchTableViewController:viewWillAppear: productCount:\(self.productArray.count)")
                    self.tableView.reloadData()
                }
            }
        } else
        {
            print("Invalid search string")
        }
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myProductCell", for: indexPath) as! ProductCell
        

        
        cell.product = productArray[indexPath.row]
        print("In SearchTableViewController:tableView:row \(indexPath.row):\(String(describing: cell.product?.description)) ")
        return cell
    }


}
