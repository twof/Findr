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

class FullContatctVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var linksTableView: UITableView!
    @IBOutlet weak var theMapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    var modelObjects = [FullConcactModel]()
    var emailTextFromTextField: String = ""
    


    @IBOutlet weak var emailTextField: UITextField!
    
    var parameters: Parameters = [:]
    
    
    
    
//[ViewDidLoad]
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextFromTextField = String(describing: searchTextField.text)

        parameters = [
            "X-Mashape-Key":" OyaoPyoyPVmshHaiD8dc5CA9GJeCp12QsDKjsnWgTnZ5Aq3nQd",
            "apiKey":"b86dca21133b8411",
            "email" : "\(emailTextFromTextField)"
        ]
        
        
        
    }
    
    
    
    
    let headers: HTTPHeaders = ["Accept": "application/json", "X-Mashape-Key":" OyaoPyoyPVmshHaiD8dc5CA9GJeCp12QsDKjsnWgTnZ5Aq3nQd"]
    
    
    @IBAction func checkButton(_ sender: UIButton) {
        
        
            parameters["email"] = "kbatista70@yahoo.com"
        print("This is for the email parameter: \(parameters["email"]!)")
        Alamofire.request("https://fullcontact.p.mashape.com/v2/person.json", method: .get, parameters: self.parameters, headers: self.headers)
        .validate(contentType: ["application/json"])
            .validate().responseJSON() { response in
        
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
                            
                            // model instance
                            let modelInstance = FullConcactModel()
                            
                            /*
                             if let type = subJson["typeName"].string {
                             modelInstance.social = type
                             print("The social network type value : \(modelInstance.social!) has been added")
                             } else {
                             modelInstance.social = "N/A"
                             }
                             */
                            
                            /*
                             if let username = subJson["username"].string {
                             modelInstance.username = username
                             print("the username value: \(modelInstance.username!) was added")
                             } else {
                             modelInstance.username = "Not available"
                             }
                             */
                            
                            //store json data in url
                            if let url = subJson["url"].string {
                                // we take the value of the url value and store it in the model instance that we'll append
                                modelInstance.link = url
                                print("the url value : \(modelInstance.link!) has been added")
                            } else {
                                modelInstance.link = "Not available"
                            }
                            
                            
                            
                            self.modelObjects.append(modelInstance)
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        //loop for photos
                        for (_, subJson) in json["photos"] {
                            
                            let photoModelInstance = FullConcactModel()
                            
                            if let type = subJson["type"].string {
                                print(type)
                                photoModelInstance.photoOrigin = type
                            }
                            
                            if let url = subJson["url"].string {
                                print(url)
                                photoModelInstance.photoURL = url
                            }
                            
                            self.modelObjects.append(photoModelInstance)
                            
                            
                        }
                        //Not having this will not show the newly downloaded data
                        self.linksTableView.reloadData()
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        //MARK: Map Code
                        let geoCoder = CLGeocoder()
                        
                        geoCoder.geocodeAddressString(String(demographics)) { (placemarks, error) -> Void in
                            
                            if error != nil {
                                print(error)
                                return
                            } else {
                                if (placemarks?.count)! > 0 {
                                    let placemark = placemarks![0]
                                    
                                    //Annotation
                                    let annotation = MKPointAnnotation()
                                    annotation.title = "Target is here!"
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
        return modelObjects.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = linksTableView.dequeueReusableCell(withIdentifier: "linksCellIdentifier") as! LinksCell
        let cellObjectsContainer = modelObjects[indexPath.row]
        //cell.originLabel.text = cellObjectsContainer.photoOrigin
        
       // if cell.originLabel.text == "" {
       //     cell.originLabel.text = "N/A"
        //}
        let link = cellObjectsContainer.link
        
        if  link != nil {
            cell.linkLabel.text = String(describing: link!)
        } else {
            
            cell.linkLabel.text = "No link available"
        }
        
        
        
        
        /*
        if url == nil {
            let URL = Foundation.URL(string: "https://httpbin.org/image/png")!
            let placeholderImage = UIImage(named: "placeholder")!
            
            cell.photoImageView.af_setImage(withURL: URL, placeholderImage: placeholderImage)
        } else {
            let placeholderImage = UIImage(named: "placeholder.png")!
            cell.photoImageView.af_setImage(withURL: url!, placeholderImage: placeholderImage)
        }
         */
        
      
        //cell.socialLabel.text = cellObjectsContainer.social
        //cell.usernameLabel.text = cellObjectsContainer.username
        
        return cell
    }
    //End of TableView code
  

    
    
    
    
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "imagesCollectionViewCell", for: indexPath) as! ImagesCollectionViewCell
        
        
        /*
        let cellObjectsContainer = modelObjects[indexPath.row].photoURL
        
        let photoURL = URL(string: cellObjectsContainer)
        
         if photoURL == nil {
             let URL = Foundation.URL(string: "https://httpbin.org/image/png")!
             let placeholderImage = UIImage(named: "placeholder")!
             collectionCell.imageView.af_setImage(withURL: URL, placeholderImage: placeholderImage)
         } else {
             print(photoURL)
             let placeholderImage = UIImage(named: "placeholder.png")!
             collectionCell.imageView.af_setImage(withURL: photoURL!, placeholderImage: placeholderImage)
         }
        
        */
        
        
        collectionCell.sourceLabel.text = "blah"
        
        
        return collectionCell
    }
        
        
    
    
    
    

//End of class
}
