//
//  SearchTableViewController.swift
//  MakeUp App
//
//  Created by ac on 4/10/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    //var tableView = UITableView()
    var searchString:String?
    //var productAPIClient:ProductAPIClient!
    var productArray:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 80
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        print("In SearchTableViewController:viewWillAppear:searchString:\(searchString)")
        
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
        
        
    } // func viewDidLoad()

    /*func didReceiveMemoryWarning() {
        //super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }*/

    // MARK: - Table view data source

    

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myProductCell", for: indexPath) as! ProductCell
        
        // Configure the cell...
        //cell.myImageView = productArray[indexPath.row].
        
        cell.product = productArray[indexPath.row]
        print("In SearchTableViewController:tableView:row \(indexPath.row):\(String(describing: cell.product?.description)) ")
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
