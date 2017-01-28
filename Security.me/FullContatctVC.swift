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

class FullContatctVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var photosTableView: UITableView!
    @IBOutlet weak var theMapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    var modelObjects = [Photos]()
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
            "email" : "\(searchTextField.text!)"
        ]
        
        
        
    }
    
    
    
    
    let headers: HTTPHeaders = ["Accept": "application/json", "X-Mashape-Key":" OyaoPyoyPVmshHaiD8dc5CA9GJeCp12QsDKjsnWgTnZ5Aq3nQd"]
    
    
    @IBAction func checkButton(_ sender: UIButton) {
        
        
            parameters["email"] = "\(searchTextField.text!)"
        print("This is for the email parameter: \(parameters["email"])")
                Alamofire.request("https://fullcontact.p.mashape.com/v2/person.json", method: .get, parameters: parameters, headers: headers)
                    .validate(contentType: ["application/json"])
                    .validate().responseJSON() { response in
                        
                
                
                
                switch response.result {
                case .success:
                     //if the call is successful, do this
                    if let value = response.result.value {
                        let json = JSON(value)
                        // print(json)
                        
                        let data = json
                        

                        
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
                            
                            let newPhotoModelInstance = Photos()

                            
                            if let type = subJson["type"].string {
                                newPhotoModelInstance.social = type
                                print("The social network type value : \(newPhotoModelInstance.social!) has been added")
                            } else {
                                newPhotoModelInstance.social = "N/A"
                            }
                            
                        
                            if let username = subJson["username"].string {
                                newPhotoModelInstance.username = username
                                print("the username value: \(newPhotoModelInstance.username!) was added")
                            } else {
                                newPhotoModelInstance.username = "Not available"
                            }
                            
                            
                            if let url = subJson["url"].string {
                                newPhotoModelInstance.link = url
                                print("the url value : \(newPhotoModelInstance.link!) has been added")
                            } else {
                                newPhotoModelInstance.link = "Not available"
                            }
                            
                            
                           
                            self.modelObjects.append(newPhotoModelInstance)



                    }
                        
                        
                        
                 
                       
                        //loop for photos
                for (_, subJson) in json["photos"] {
                            
                            let photoModelInstance = Photos()
                            
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
                        self.photosTableView.reloadData()
                      

                        
                        
                   
                        
                       
                       
                        
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
        let cell = photosTableView.dequeueReusableCell(withIdentifier: "photoCellIdentifier") as! photosCell
        let cellObjectsContainer = modelObjects[indexPath.row]
        cell.originLabel.text = cellObjectsContainer.photoOrigin
        
        if cell.originLabel.text == "" {
            cell.originLabel.text = "N/A"
        }
        
        let url = URL(string: cellObjectsContainer.photoURL)
        
        
       
        
        if url == nil {
            let URL = Foundation.URL(string: "https://httpbin.org/image/png")!
            let placeholderImage = UIImage(named: "placeholder")!
            
            cell.photoImageView.af_setImage(withURL: URL, placeholderImage: placeholderImage)
        } else {
            let placeholderImage = UIImage(named: "placeholder.png")!
            cell.photoImageView.af_setImage(withURL: url!, placeholderImage: placeholderImage)
        }
        
      
        cell.socialLabel.text = cellObjectsContainer.social
        cell.usernameLabel.text = cellObjectsContainer.username
        cell.linkLabel.text = cellObjectsContainer.link
        return cell
    }
    //End of TableView code
  

  
    
    
    

//End of class
}
