//
//  SearchViewController.swift
//  MakeUp App
//
//  Created by Amit Chadha on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase

class SearchViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate, UISearchBarDelegate  {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    let resultStore = ResultStore.sharedInstance
    
    var lastBarCodevalue: String?
    
    //for barCodeDetails & DB addition
    var apiData = [String:Any]()
    var ref: FIRDatabaseReference {
        return FIRDatabase.database().reference(withPath: "Products")
    }
    
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code]
    
    var searchBar:UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lastBarCodevalue = nil
        
        NotificationCenter.default.post(name: .searchVC, object: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar(title: "Search or Scan", leftButton: nil, rightButton: nil)

        view.backgroundColor = Palette.white.color
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)  // videoPreviewLayer used earlier
            
            captureSession?.startRunning()
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            print(error)
            return
        }
    
        configureSearchController()
   
    }
    
    func configureSearchController() {
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.frame.size = CGSize(width: (navigationController?.navigationBar.frame.width)!, height: (navigationController?.navigationBar.frame.height)!)
    
        view.addSubview(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchQuery = searchBar.text {
            UserStore.sharedInstance.searchQuery = searchQuery
            
            let searchTableView = SearchTableViewController()
            self.navigationController?.pushViewController(searchTableView, animated: true)
        }

    }
 
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            //messageLabel.text = "No barcode is detected"
            print("No barcode is detected")
            return
        }
        
        // Get the metadata object.
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else { print("Cannot get metadataObj"); return   }
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            if let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj) {
                qrCodeFrameView?.frame = barCodeObject.bounds
            } else {
                print("Cannot create barCodeObject")
            }
            
            if let barCodeValue = metadataObj.stringValue {
                //messageLabel.text = metadataObj.stringValue
                print("Barcode value:\(barCodeValue)")
                if lastBarCodevalue == barCodeValue { return } else {
                    lastBarCodevalue = barCodeValue
                }
                let startIndex = barCodeValue.startIndex
                var newBarCodeValue:String
                if barCodeValue[startIndex] == "0" {
                    let index = barCodeValue.index(startIndex, offsetBy: 1)
                    newBarCodeValue = barCodeValue.substring(from: index)
                } else {
                    newBarCodeValue = barCodeValue
                }
                print("New Barcode value:\(newBarCodeValue)")
                
                //Search Firebase
                searchDB(barCode: newBarCodeValue) { (val) in
                    if val != nil {
                        print("Value found in DB")
                        self.resultStore.product = Product(dict: val!)
                        NotificationCenter.default.post(name: .productVC, object: nil)
                    }
                    else {
                        print("Searching barcode on internet")
                        self.barCodeSearch(barCode: newBarCodeValue, completion: { (product) in
                            self.resultStore.product = product
                            NotificationCenter.default.post(name: .productVC, object: nil)
                        }
                        )}
                    
                }
            }
            else {
                print("Scanned barcode value is nil")
            }
            
        }
    }
    
    func barCodeSearch(barCode:String, completion: @escaping (Product) -> Void) {
        print("In barCodeSearch barCode: \(barCode)")
        
        let url = URL(string: "https://api.upcitemdb.com/prod/trial/lookup?upc=\(barCode)")
        guard let unwrappedUrl = url else { print("Invalid Url"); return }
        let task = URLSession.shared.dataTask(with: unwrappedUrl) { (data, response, error) in
            if let unwrappedData = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? [String:Any] else {
                        print("Invalid JSONSerialization"); return
                    }
                    guard let targetdata = json["items"] as? [[String:Any]] else {
                        print("Cannot convert json to dictionary array"); return
                    }
                    self.apiData = targetdata[0]
                    
                    let imageArray = self.apiData["images"] as? [String] ?? ["No image"]

                    var imageUrl = "No Image"
                    if !(imageArray.isEmpty) {
                        imageUrl = imageArray[0]
                    } else {
                        imageUrl = "No Image" ;
                        print("imageArray is empty")
                    }
                    
                    let offersArray = self.apiData["offers"] as? [Any] ?? ["No Offers"]
                    print("offersArray is", offersArray)

                    let firstOffer = offersArray[0] as? [String:Any] ?? [:]
                    let price = firstOffer["price"]
                                        
                    self.apiData["image"] = imageUrl
                    self.apiData["price"] = price
                    
                    let product = Product(dict:self.apiData)
                    self.addToDB(product)
                    completion(product)
                } catch {  }
            }
            
        }
        task.resume()
        
    }
    
    
    //add dictionary item to DB
    func addToDB(_ itemDet:Product) {
        let itemRef = self.ref.child(itemDet.upc)
        itemRef.setValue(itemDet.toDict())   //convert to desired dict obj
        
    }
    
    //search DB for code
    func searchDB(barCode:String, completion:@escaping ([String:Any]?)->()) {
        
        self.ref.child(barCode).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String:Any] //else {print("Cannot convert snapshot to [String:Any]"); return  }
            completion(value)
        })
        
    }
    
    
    
}


