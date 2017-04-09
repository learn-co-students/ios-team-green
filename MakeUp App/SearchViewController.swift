//
//  SearchViewController.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase

class SearchViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    let resultStore = ResultStore.sharedInstance
    
    var finishedSearch = false
    
    
    //for barCodeDetails & DB addition
    var apiData:[String:Any] = [:]
    var outPutStr = String()
    var ref:FIRDatabaseReference!
    
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code /*,
         AVMetadataObjectTypeQRCode*/]
    
    override func viewWillAppear(_ animated: Bool) {
        print("view appeared at 42")
        super.viewWillAppear(true)
        finishedSearch = false
        print("finished search is", finishedSearch)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference(withPath: "Products")
        
        view.backgroundColor = Palette.white.color
        print("search view")
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)  // videoPreviewLayer used earlier
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Move the message label and top bar to the front
            //view.bringSubview(toFront: messageLabel)
            //view.bringSubview(toFront: lastMessageLabel)
            //view.bringSubview(toFront: topbar)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
    } //func viewDidLoad()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            if metadataObj.stringValue != nil {
                //messageLabel.text = metadataObj.stringValue
                print("Barcode value:\(metadataObj.stringValue)")
                
                //save the last barcode scanned
                
                /*if metadataObj.stringValue != lastMessageLabel.text {
                 
                 lastMessageLabel.text = "Last code scanned:\(metadataObj.stringValue!)"
                 }*/
                
                //Search Firebase
                searchDB(barCode: metadataObj.stringValue!) { (val) in
                    if val != nil {
                        print("Value found in DB")
                        self.navigationController?.pushViewController(ResultsViewController(), animated: true)
                    }
                    else if self.finishedSearch == false {
                        self.finishedSearch = true
                        print("about to do a barcode search")
                        self.barCodeSearch(barCode: metadataObj.stringValue!, completion: { (Product) in
                            DispatchQueue.main.async {
                                
                                self.resultStore.product = Product
                                self.navigationController?.pushViewController(ResultsViewController(), animated: true)
                            }
                            
                        }
                        )}
                    else {
                        print("not searching")
                    }
                }
            }
            
        }
    }
    
    func barCodeSearch(barCode:String, completion: @escaping (Product) -> Void) {
        //https://api.upcitemdb.com/prod/trial/lookup?upc=searchText
        print("In barCodeSearch barCode: \(barCode)")
        
        //textLabelOutlet.text = "Searched BarCode \(barCode)\n\n"
        outPutStr = "Searched BarCode \(barCode)\n\n"
        let url = URL(string: "https://api.upcitemdb.com/prod/trial/lookup?upc=\(barCode)")
        guard let unwrappedUrl = url else { print("Invalid Url"); return }
        let task = URLSession.shared.dataTask(with: unwrappedUrl) { (data, response, error) in
            if let unwrappedData = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? [String:Any] else {
                        print("Invalid JSONSerialization"); return
                    }
                    //print("json=\(json)")
                    guard let targetdata = json["items"] as? [[String:Any]] else {
                        print("targetdata is nil. Cannot convert json to dictionary array"); return
                    }
                    print("targetdata=\(targetdata[0])")
                    self.apiData = targetdata[0]
                    
                    let ean = self.apiData["ean"] as? String ?? "Invalid EAN"
                    let brand = self.apiData["brand"] as? String ?? "Invalid Brand"
                    let imageArray = self.apiData["images"] as? [String] ?? ["No image"]
                    let image = imageArray[0] as? String ?? "No image"
                    self.outPutStr +=  "EAN: " + ean + "\n" +
                        "Brand: " + brand + "\n"
                    self.apiData["image"] = image
                    print("THE DICITONARY IMAGES IS", self.apiData["images"]!)
                    let product = Product(dict:self.apiData)
                    self.addToDB(product)
                    completion(product)
                } catch {  }
            }
            
        }
        task.resume()
        
    } //func barCodeSearch
    
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
        
    } // func searchDB
    
    
}
