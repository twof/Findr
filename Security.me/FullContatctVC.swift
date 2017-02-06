//
//  FullContatctVC.swift
//  Security.me
//
//  Created by Kenny Batista on 7/7/16.
//  Copyright © 2016 Kenny Batista. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MapKit
import AlamofireImage
import AlamofireNetworkActivityIndicator
import MessageUI
import SafariServices
import StoreKit
<<<<<<< HEAD
import SwiftyStoreKit
=======

>>>>>>> d6b35a7927ad46a98f43e06b72fb5dd082e60827

let sharedSecret = "9252bdd1aa974e3c8413e4913de34bae"

// organize our product 
enum RegisteredPurchase : String {
    case enablemap = "enablemap"
    case autoRenewable = "autoRenewable"
}

//Handle connection
class NetworkActivityIndicatorManager : NSObject {
    
    private static var loadingCount = 0
    
    class func NetworkOperationStarted() {
        if loadingCount == 0 {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loadingCount += 1
    }
    
    class func networkOperationFinished(){
        if loadingCount > 0 {
            loadingCount -= 1
            
        }
        
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }
    }
}



@available(iOS 9.0, *)
<<<<<<< HEAD
class FullContatctVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, MFMessageComposeViewControllerDelegate {
//start of IAP
    @IBOutlet var MoneyLbl: UILabel!
    
    var Money = Int()
    
    let bundleID = "com.kennybatista.findr"
    
    var enablemap = RegisteredPurchase.enablemap
//    var RemoveAds = RegisteredPurchase.RemoveAds
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        self.MoneyLbl.text = "\(self.Money)"
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Consumable1(_ sender: Any) {
        purchase(purchase: enablemap)
    }
    
    @IBAction func Consumable2(_ sender: Any) {
//        purchase(purchase: RemoveAds)
    }
    
    @IBAction func Renewable(_ sender: Any) {
        
    }
    
    @IBAction func NonRenewable(_ sender: Any) {
    }
    
    
    
    func getInfo(purchase : RegisteredPurchase) {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([bundleID + "." + purchase.rawValue], completion: {
            result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            self.showAlert(alert: self.alertForProductRetrievalInfo(result: result))
            
            
        })
    }
    
    func purchase(purchase : RegisteredPurchase) {
        print(#function)
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.purchaseProduct(bundleID + "." + purchase.rawValue, completion: {
            result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            print(result)
            if case .success(let product) = result {
                print("Success")
                if product.productId == self.bundleID + "." + "enablemap"{
                    
//                    self.Money += 10
//                    self.MoneyLbl.text = "\(self.Money)"
                    
                }
//                if product.productId == self.bundleID + "." + "RemoveAds" {
//                    
////                    self.Money += 100
////                    self.MoneyLbl.text = "\(self.Money)"
//                }
                
                if product.needsFinishTransaction {
                    print("Needs to finish transaction, alert won't show up")
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                self.showAlert(alert: self.alertForPurchaseResult(result: result))
            }
            
            
        })
        
    }
    func restorePurchases() {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true, completion: {
            result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            for product in result.restoredProducts {
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
            }
            
            self.showAlert(alert: self.alertForRestorePurchases(result: result))
            
        })
    }
    func verifyReceipt() {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.verifyReceipt(using: sharedSecret as! ReceiptValidator, completion: {
            result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            self.showAlert(alert: self.alertForVerifyReceipt(result: result))
            
            if case .error(let error) = result {
                if case .noReceiptData = error {
                    
                    self.refreshReceipt()
                    
                }
            }
            
        })
        
    }
    func verifyPurcahse(product : RegisteredPurchase) {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.verifyReceipt(using: sharedSecret as! ReceiptValidator, completion: {
            
            result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            switch result{
            case .success(let receipt):
                
                let productID = self.bundleID + "." + product.rawValue
                
                if product == .autoRenewable {
                    let purchaseResult = SwiftyStoreKit.verifySubscription(productId: productID, inReceipt: receipt, validUntil: Date())
                    self.showAlert(alert: self.alertForVerifySubscription(result: purchaseResult))
                    
                }
                else {
                    let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: productID, inReceipt: receipt)
                    self.showAlert(alert: self.alertForVerifyPurchase(result: purchaseResult))
                    
                }
            case .error(let error):
                self.showAlert(alert: self.alertForVerifyReceipt(result: result))
                if case .noReceiptData = error {
                    self.refreshReceipt()
                    
                }
                
            }
            
            
        })
        
    }
    func refreshReceipt() {
        SwiftyStoreKit.refreshReceipt(completion: {
            result in
            
            self.showAlert(alert: self.alertForRefreshRecepit(result: result))
            
        })
        
    }

//end of IAP
=======
class FullContatctVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, MFMessageComposeViewControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver  {
>>>>>>> d6b35a7927ad46a98f43e06b72fb5dd082e60827
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var linksTableView: UITableView!
    @IBOutlet weak var theMapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var searchButtonOutlet: UIButton!
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    var modelObjects = [FullConcactModel]()
    var emailTextFromTextField: String = ""
    
    var images = [String]()
    var imageSource = [String]()
    var linksSource = [String]()
    var linksArray = [String]()
    
    var parameters: Parameters = [:]
    
<<<<<<< HEAD
    @IBOutlet weak var mapOverlayViewToBeRemovedAfterPurchase: UIView!
=======
    // in app purchases
    @IBOutlet weak var enableMapOutlet: UIButton!
    
    var listOfProducts = [SKProduct]()
    var currentProduct = SKProduct()
    
>>>>>>> d6b35a7927ad46a98f43e06b72fb5dd082e60827
    
    @IBAction func enableMapAfterPurchaseButton(_ sender: Any) {
        print(#function)
        purchase(purchase: .enablemap)
    }
    
//[ViewDidLoad]
    override func viewDidLoad() {
        print("Entered ViewDidLoad")
        super.viewDidLoad()
        emailTextFromTextField = String(describing: searchTextField.text)
        
//        searchButtonOutlet
        
        parameters = [
            "X-Mashape-Key":" OyaoPyoyPVmshHaiD8dc5CA9GJeCp12QsDKjsnWgTnZ5Aq3nQd",
            "apiKey":"b86dca21133b8411",
            "email" : "\(searchTextField.text)"
        ]
        
        imageSource.append("Search First")
        images.append("https://openclipart.org/image/2400px/svg_to_png/177482/ProfilePlaceholderSuit.png")
        linksSource.append("Search first")
        linksArray.append("www.search_first.com")
        
        
        enableMapOutlet.isEnabled = false
        
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            let productID: NSSet = NSSet(objects: "findr.enablemap", "findr.consulting")
            print(productID)
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("please enable IAPS")
        }
        
        
        
    }
    
    
    //rate my app:
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    
    
    // headers to feed the api call
    let headers: HTTPHeaders = ["Accept": "application/json", "X-Mashape-Key":" OyaoPyoyPVmshHaiD8dc5CA9GJeCp12QsDKjsnWgTnZ5Aq3nQd"]
    
//[Help Button]
    @IBAction func helpButtonAction(_ sender: UIButton) {
        print(#function)
        let alertController = UIAlertController(title: "Hey!", message: "Need help or want to provide some feedback? Just tap below:", preferredStyle: .alert)
        
        
        // feedback or help action button
        let helpOrFeedbackAction = UIAlertAction(title: "Feedback", style: .default) { (UIAlertAction) in
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = "Hello team Findr! I've got something to tell you: "
                controller.recipients = ["13477920858"]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
        }
        
        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // rate app action button
        let rateButton = UIAlertAction(title: "Rate", style: .default) { (UIAlertAction) in
            self.rateApp(appId: "id1201439669", completion: { success in
                print("RateApp \(success)")
            })
        }
        
        
        // add action buttons to alert controller
        alertController.addAction(helpOrFeedbackAction)
        alertController.addAction(rateButton)
        alertController.addAction(cancelAction)
        
        // present the controller
        self.present(alertController, animated: true, completion: nil)
        
        
        

    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        // handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }

    
    
    
//[Search for email Button]
    @IBAction func checkButton(_ sender: UIButton) {
        
        parameters["email"] = searchTextField.text
        print("This is for the email parameter: \(parameters["email"]!)")
        Alamofire.request("https://fullcontact.p.mashape.com/v2/person.json", method: .get, parameters: self.parameters, headers: self.headers)
        .validate(contentType: ["application/json"])
            .validate().responseJSON() { response in
                self.imageSource.removeAll()
                self.images.removeAll()
                self.linksArray.removeAll()
                self.linksSource.removeAll()
                
                print("These are the images and images source\(self.images, self.imageSource)")
                print("Request Sent out")
        
                switch response.result {
                case .success:
                    //if the call is successful, do this
                    if let value = response.result.value {
                        let json = JSON(value)
                        // print(json)
                        
                        let data = json
                        
                        
                        //Person Request
                        //location
                        let demographics = data["demographics"]["locationDeduced"]["deducedLocation"].stringValue
                        print(demographics)
                        self.locationLabel.text = demographics
                        
                        
                        //gender
                        let gender = data["demographics"]["gender"].stringValue
                        print(gender)
                        self.genderLabel.text = String(gender)
                        
                        //Person info
                        let name = data["contactInfo"]["fullName"]
                        self.nameLabel.text = String(describing: name)
                        print(name)
                        
                        
                        
                        
                        
                        
                        // MARK: loop social profiles
                        for (_, subJson) in json["socialProfiles"] {
                            
                            if let linkSource = subJson["typeName"].string {
                                self.linksSource.append(linkSource)
                            }
                            
                            //store json data in url
                            if let url = subJson["url"].string {
                                
                                self.linksArray.append(url)
                            } else {
                                self.linksArray.append("Not available")
                            }
    
                        }
                        
                        
                        
                        
                        
                        //loop for photos
                        for (_, subJson) in json["photos"] {
                            
                            // Photo origin
                            if let type = subJson["typeName"].string {
                                print(type)
                                
                                self.imageSource.append("\(type) Image")
                                
                            }
                            
                            //Photo links
                            if let url = subJson["url"].string {
                                print(url)
                                
                                
                                self.images.append(url)
                            }
                        }
                        
                        print("This is the imagesource and linksarray: \(self.imageSource, self.linksArray)")
                        self.imagesCollectionView.reloadData()
                        self.linksTableView.reloadData()
                        
                        
                        
//MARK: Map Code
                        let geoCoder = CLGeocoder()
                        
                        geoCoder.geocodeAddressString(String(demographics)) { (placemarks, error) -> Void in
                            
                            if error != nil {
                                print(error!)
                                return
                            } else {
                                if (placemarks?.count)! > 0 {
                                    let placemark = placemarks![0]
                                    
                                    //Annotation
                                    let annotation = MKPointAnnotation()
                                    annotation.title = "Location found online: "
                                    annotation.subtitle = "\(demographics)"
                                    annotation.coordinate = (placemark.location?.coordinate)!
                                    
                                    //show the annotation
                                    self.theMapView.showAnnotations([annotation], animated: true)
                                    self.theMapView.selectAnnotation(annotation, animated: true)
                                }
                            }
                        }
                    }
                //End of success .case
                case .failure(let error):
                    print(error)
                    print("There is an error")
                    
                }
                
                //Hide keyboard when finished editing
                self.view.endEditing(true)

        }
        
    }
    
    

    //MARK: TableView Code
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return linksArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = linksTableView.dequeueReusableCell(withIdentifier: "linksCellIdentifier") as! LinksCell
        
        
        cell.linkLabel.text = linksArray[indexPath.row]
        cell.sourceLabel.text = linksSource[indexPath.row]
        
        return cell
    }
    //End of TableView code
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = linksArray[indexPath.row]
        
        //Alert
        let alertController = UIAlertController(title: "Open link in browser?", message: "Tap below to see what the internet is storing about you", preferredStyle: .alert)
        
        let openBrowserAction = UIAlertAction(title: "Open", style: .default) { (UIAlertAction) in
        
            let url = URL(string: link)
            let safariVC = SFSafariViewController(url: url!)
            self.present(safariVC, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(openBrowserAction)
        
        
        self.present(alertController, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
            
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "imagesCollectionViewCell", for: indexPath) as! ImagesCollectionViewCell

        
        let photoURL = URL(string: images[indexPath.row])
        // if success
        if photoURL != nil {
            
            let placeholderImage = UIImage(named: "placeholder.png")!
            collectionCell.imageView.af_setImage(withURL: photoURL!, placeholderImage: placeholderImage)
        // if no success
        } else {
            let URL = Foundation.URL(string: "https://openclipart.org/image/2400px/svg_to_png/177482/ProfilePlaceholderSuit.png")!
            let placeholderImage = UIImage(named: "placeholder.png")!
            collectionCell.imageView.af_setImage(withURL: URL, placeholderImage: placeholderImage)
        }
        
        
        
        collectionCell.sourceLabel.text = imageSource[indexPath.row]
        collectionCell.layer.cornerRadius = 8
        
        return collectionCell
    }
        
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //In-APP purchases
    @IBAction func EnableMap(_ sender: Any) {
        print("enable maps")
        for product in listOfProducts {
            let prodID = product.productIdentifier
            if(prodID == "findr.enablemap") {
                self.currentProduct = product
                buyProduct()
            }
        }
    }
    
    
    
    func enableMap(){
        enableMapOutlet.removeFromSuperview()
    }
    
    
    func buyProduct() {
        print("buy " + currentProduct.productIdentifier)
        let pay = SKPayment(product: currentProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
    }
    
   
    
    // this function connects to itunes connect and asks for a list of in app purchases, and then in here if we have items that the user can shop from we can return them and add them to a lisst where we'll then print out to make sure that the users is connected and can shop. Also, we enable the buttons so that the user can shop
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Products Requested - you should receive a list of products now")
        let products = response.products
        print(products)
        for product in products {
            print("Product Added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            listOfProducts.append(product)
        }
        
        searchButtonOutlet.isEnabled = true
        
        
    }
    
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("Transaction restored")
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            let proID = t.payment.productIdentifier as String
            
            switch proID {
            case "findr.enablemap":
                enableMap()
            case "consulting":
                enableMap()
            default:
                print("IAP not found")
            }
        }
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("Add payment")
        
        for transaction: AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState {
            case .purchased:
                print("buy ok, unlock IAP HERE")
                print(currentProduct.productIdentifier)
                
                let prodID = currentProduct.productIdentifier
                switch prodID {
                case "findr.enablemap":
                    print("findr.enablemap")
//                    removeAds()
                case "findr.consulting":
                    print("consulting")
//                    addCoins()
                default:
                    print("IAP not found")
                }
                queue.finishTransaction(trans)
            case .failed:
                print("buy error")
                queue.finishTransaction(trans)
                break
            default:
                print("Default")
                break
            }
        }
    }
//End of class
}


<<<<<<< HEAD
@available(iOS 9.0, *)
extension FullContatctVC {
    
    func alertWithTitle(title : String, message : String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
        
    }
    func showAlert(alert : UIAlertController) {
        guard let _ = self.presentedViewController else {
            self.present(alert, animated: true, completion: nil)
            return
        }
        
    }
    func alertForProductRetrievalInfo(result : RetrieveResults) -> UIAlertController {
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice!
            return alertWithTitle(title: product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
            
        }
        else if let invalidProductID = result.invalidProductIDs.first {
            return alertWithTitle(title: "Could not retreive product info", message: "Invalid product identifier: \(invalidProductID)")
        }
        else {
            let errorString = result.error?.localizedDescription ?? "Unknown Error. Please Contact Support"
            return alertWithTitle(title: "Could not retreive product info" , message: errorString)
            
        }
        
    }
    func alertForPurchaseResult(result : PurchaseResult) -> UIAlertController {
        switch result {
        case .success(let product):
            print("Purchase Succesful: \(product.productId)")
            
            return alertWithTitle(title: "Thank You", message: "Purchase completed")
        case .error(let error):
            print("Purchase Failed: \(error)")
            switch error {
            case .failed(let error):
                if (error as NSError).domain == SKErrorDomain {
                    return alertWithTitle(title: "Purchase Failed", message: "Check your internet connection or try again later.")
                }
                else {
                    return alertWithTitle(title: "Purchase Failed", message: "Unknown Error. Please Contact Support")
                }
            case.invalidProductId(let productID):
                return alertWithTitle(title: "Purchase Failed", message: "\(productID) is not a valid product identifier")
//            case .noProductIdentifier:
//                return alertWithTitle(title: "Purchase Failed", message: "Product not found")
            case .paymentNotAllowed:
                return alertWithTitle(title: "Purchase Failed", message: "You are not allowed to make payments")
                
            }
        }
    }
    func alertForRestorePurchases(result : RestoreResults) -> UIAlertController {
        if result.restoreFailedProducts.count > 0 {
            print("Restore Failed: \(result.restoreFailedProducts)")
            return alertWithTitle(title: "Restore Failed", message: "Unknown Error. Please Contact Support")
        }
        else if result.restoredProducts.count > 0 {
            return alertWithTitle(title: "Purchases Restored", message: "All purchases have been restored.")
            
        }
        else {
            return alertWithTitle(title: "Nothing To Restore", message: "No previous purchases were made.")
        }
        
    }
    func alertForVerifyReceipt(result: VerifyReceiptResult) -> UIAlertController {
        
        switch result {
        case.success(let receipt):
            return alertWithTitle(title: "Receipt Verified", message: "Receipt Verified Remotely")
        case .error(let error):
            switch error {
            case .noReceiptData:
                return alertWithTitle(title: "Receipt Verification", message: "No receipt data found, application will try to get a new one. Try Again.")
            default:
                return alertWithTitle(title: "Receipt verification", message: "Receipt Verification failed")
            }
        }
    }
    func alertForVerifySubscription(result: VerifySubscriptionResult) -> UIAlertController {
        switch result {
        case .purchased(let expiryDate):
            return alertWithTitle(title: "Product is Purchased", message: "Product is valid until \(expiryDate)")
        case .notPurchased:
            return alertWithTitle(title: "Not purchased", message: "This product has never been purchased")
        case .expired(let expiryDate):
            
            return alertWithTitle(title: "Product Expired", message: "Product is expired since \(expiryDate)")
        }
    }
    func alertForVerifyPurchase(result : VerifyPurchaseResult) -> UIAlertController {
        switch result {
        case .purchased:
            return alertWithTitle(title: "Product is Purchased", message: "Product will not expire")
        case .notPurchased:
            
            return alertWithTitle(title: "Product not purchased", message: "Product has never been purchased")
            
            
        }
        
    }
    func alertForRefreshRecepit(result : RefreshReceiptResult) -> UIAlertController {
        
        switch result {
        case .success(let receiptData):
            return alertWithTitle(title: "Receipt Refreshed", message: "Receipt refreshed successfully")
        case .error(let error):
            return alertWithTitle(title: "Receipt refresh failed", message: "Receipt refresh failed")
        }
    }
    
}

=======
>>>>>>> d6b35a7927ad46a98f43e06b72fb5dd082e60827
