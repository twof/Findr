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
import SafariServices
import StoreKit
import MessageUI
import Social


let sharedSecret = "9252bdd1aa974e3c8413e4913de34bae"

@available(iOS 9.0, *)
class FullContatctVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, MFMailComposeViewControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {

  

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
    
    

    @IBOutlet weak var mapOverlayViewToBeRemovedAfterPurchase: UIImageView!
    
    @IBOutlet weak var labelOverlay: UIImageView!
    
    
    @IBOutlet weak var mapoverlayBTN: UIButton!
    
    @IBOutlet weak var labelOverlayBTN: UIButton!
    
    
    
    // Create this globally
    let defaults = UserDefaults.standard
    
    
    
    @IBAction func shareOnFacebook(_ sender: Any) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            let itunes = URL(string: "http://apple.co/2kSz5bL")
            fbShare.add(itunes)
            self.present(fbShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    @IBAction func shareOnTwitter(_ sender: Any) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            
            let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            let itunes = URL(string: "http://apple.co/2kSz5bL")
            tweetShare.add(itunes)
            self.present(tweetShare, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }

    }
    
//[ViewDidLoad]
    
    
    override func viewDidLoad() {
        print("Entered ViewDidLoad")
        super.viewDidLoad()
        
        
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            let productID: NSSet = NSSet(objects: "com.kennybatista.findr.enablemap")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("please enable IAPS")
        }
        
        

        
        if !defaults.bool(forKey: "com.kennybatista.findr.enablemap") {
            // IAP not purchased - so prevent the user from using features until they pay
            
            mapOverlayViewToBeRemovedAfterPurchase.isHidden = false
            labelOverlay.isHidden = false
            mapoverlayBTN.isEnabled = false
            labelOverlayBTN.isEnabled = false
        } else {
            // IAP are purchased - allow users to see
            mapOverlayViewToBeRemovedAfterPurchase.isHidden = true
            mapoverlayBTN.isHidden = true
            labelOverlayBTN.isHidden = true
            labelOverlay.isHidden = true
        }
        
        
        
        emailTextFromTextField = String(describing: searchTextField.text)
        
//        searchButtonOutlet
        
        parameters = [
            "X-Mashape-Key":" OyaoPyoyPVmshHaiD8dc5CA9GJeCp12QsDKjsnWgTnZ5Aq3nQd",
            "apiKey":"b86dca21133b8411",
            "email" : "\(searchTextField.text)"
        ]
        
        imageSource.append("No Image")
        images.append("https://openclipart.org/image/2400px/svg_to_png/177482/ProfilePlaceholderSuit.png")
        linksSource.append("Links retrieved")
        linksArray.append("www.presssearchfirst.com")
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
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["findrappusa@gmail.com"])
                mail.setMessageBody("<p>Hello Team Findr! I've got something to tell you ...</p>", isHTML: true)
                
                self.present(mail, animated: true)
            } else {
                // show failure alert
            }        }
        
        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // rate app action button
        let rateButton = UIAlertAction(title: "Rate", style: .default) { (UIAlertAction) in
            self.rateApp(appId: "id1201439669", completion: { success in
                print("RateApp \(success)")
            })
        }
        
        let restorePurchasesButton = UIAlertAction(title: "Restore In-App-Purchases", style: .default, handler: { UIAlertAction in
            if (SKPaymentQueue.canMakePayments()) {
                SKPaymentQueue.default().restoreCompletedTransactions()
                
//                let alert = UIAlertController(title: "Restoring", message: "Your purchases will be restored", preferredStyle: .alert)
//                self.present(alert, animated: true, completion: nil)
            }
            
        })
        
        
        // add action buttons to alert controller
        alertController.addAction(helpOrFeedbackAction)
        alertController.addAction(rateButton)
        alertController.addAction(restorePurchasesButton)
        alertController.addAction(cancelAction)
        
        // present the controller
        self.present(alertController, animated: true, completion: nil)
        
        
        

    }
    
    
    //Start compose email
 

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    //end compose email

    
    
    
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
                    let alertController = UIAlertController(title: "😢|😀", message: "Invalid e-mail, or we haven't found data on you!", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "Aww/Woohoo!", style: .default, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
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
    

//End of class
    
    
    
    
    
    @IBAction func enableMapsandLocationBTN(_ sender: Any) {
        print("enable maps")
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "com.kennybatista.findr.enablemap") {
                p = product
                buyProduct()
            }
        }
    }
  
    @IBAction func enableMapsBTN(_ sender: Any) {
        print("enable maps")
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "com.kennybatista.findr.enablemap") {
                p = product
                buyProduct()
            }
        }
    }
    
//    @IBAction func btnAddCoins(_ sender: Any) {
//        for product in list {
//            let prodID = product.productIdentifier
//            if(prodID == "seemu.iap.addcoins") {
//                p = product
//                buyProduct()
//            }
//        }
//    }
    
    @IBAction func btnRestorePurchases(_ sender: Any) {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func buyProduct() {
        print("buy " + p.productIdentifier)
        let pay = SKPayment(product: p)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
    }
    
//    func removeAds() {
//        lblAd.removeFromSuperview()
//    }
//    
//    func addCoins() {
//        coins += 50
//        lblCoinAmount.text = "\(coins)"
//    }
    
    var list = [SKProduct]()
    var p = SKProduct()
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("product request")
        let myProduct = response.products
        for product in myProduct {
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            list.append(product)
        }
        
        mapoverlayBTN.isEnabled = true
        labelOverlayBTN.isEnabled = true
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("transactions restored")
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "com.kennybatista.findr.enablemap":
                print("enable maps")
                enableMap()
//            case "seemu.iap.addcoins":
//                print("add coins to account")
//                addCoins()
            default:
                print("IAP not found")
            }
        }
    }
    
    func enableMap(){
        mapOverlayViewToBeRemovedAfterPurchase.isHidden = true
        mapoverlayBTN.isHidden = true
        labelOverlayBTN.isHidden = true
        labelOverlay.isHidden = true

        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        
        for transaction: AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print(trans.error!)
            
            switch trans.transactionState {
            case .purchased, .restored:
                print("buy ok, unlock IAP HERE")
                print(p.productIdentifier)
                
                let prodID = p.productIdentifier
                switch prodID {
                    case "com.kennybatista.findr.enablemap":
                        print("enable maps")
                        enableMap()
                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                        // Upon the successful purchase of your IAP you set the key to true
                        defaults.set(true, forKey: "com.kennybatista.findr.enablemap")
                        UserDefaults.standard.synchronize()
                        //  case "seemu.iap.addcoins":
    //                    print("add coins to account")
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


    
    
    
    
}










