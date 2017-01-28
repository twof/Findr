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
    
    var images = [String]()
    var imageSource = [String]()
    var linksArray = [String]()

    @IBOutlet weak var emailTextField: UITextField!
    
    var parameters: Parameters = [:]
    
    
    
    
//[ViewDidLoad]
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextFromTextField = String(describing: searchTextField.text)

        parameters = [
            "X-Mashape-Key":" OyaoPyoyPVmshHaiD8dc5CA9GJeCp12QsDKjsnWgTnZ5Aq3nQd",
            "apiKey":"b86dca21133b8411",
            "email" : "\(searchTextField.text)"
        ]
        
        
        
    }
    
    
    
    
    let headers: HTTPHeaders = ["Accept": "application/json", "X-Mashape-Key":" OyaoPyoyPVmshHaiD8dc5CA9GJeCp12QsDKjsnWgTnZ5Aq3nQd"]
    
    
    @IBAction func checkButton(_ sender: UIButton) {
        
        
        parameters["email"] = searchTextField.text
        print("This is for the email parameter: \(parameters["email"]!)")
        Alamofire.request("https://fullcontact.p.mashape.com/v2/person.json", method: .get, parameters: self.parameters, headers: self.headers)
        .validate(contentType: ["application/json"])
            .validate().responseJSON() { response in
                self.imageSource = [""]
                self.images = [""]
                self.linksArray = [""]
                
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
                            
                            
                            
                            //store json data in url
                            if let url = subJson["url"].string {
                                // we take the value of the url value and store it in the model instance that we'll append
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
                                
                                self.imageSource.append(type)
                                
                            }
                            
                            //Photo links
                            if let url = subJson["url"].string {
                                print(url)
                                
                                
                                self.images.append(url)
                            }
                        }
                        
                        
                        self.imagesCollectionView.reloadData()
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
        
        
        cell.linkLabel.text = linksArray[indexPath.row]
     
        
        return cell
    }
    //End of TableView code
  

    
    
    
    
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageSource.count
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
        
        
        let photoURL = URL(string: images[indexPath.row])
        // if success
        if photoURL != nil {
            
            let placeholderImage = UIImage(named: "placeholder.png")!
            collectionCell.imageView.af_setImage(withURL: photoURL!, placeholderImage: placeholderImage)
        // if no success
        } else {
            let URL = Foundation.URL(string: "https://httpbin.org/image/png")!
            let placeholderImage = UIImage(named: "placeholder")!
            collectionCell.imageView.af_setImage(withURL: URL, placeholderImage: placeholderImage)
        }
        
        
        
        collectionCell.sourceLabel.text = imageSource[indexPath.row]
        
        
        return collectionCell
    }
        
        
    
    
    
    

//End of class
}
