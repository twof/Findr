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
    
    
    
    
    //MARK: TableView Code
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosObjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = photosTableView.dequeueReusableCellWithIdentifier("photoCellIdentifier") as! photosCell
        
        
        let photoContainer = photosObjects[indexPath.row]
        cell.originLabel.text = photoContainer.photoOrigin
        let url = NSURL(string: photoContainer.photoURL)
        cell.photoImageView.af_setImageWithURL(url!)
        
        
                cell.socialLabel.text = photoContainer.social
                cell.usernameLabel.text = photoContainer.username
                cell.linkLabel.text = photoContainer.link
        return cell
    }
    //End of TableView code

    

    
    var photosObjects = [Photos]()
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBAction func checkButton(sender: UIButton) {
        Alamofire.request(.GET, "https://fullcontact.p.mashape.com/v2/person.json", headers: [ "Accept": "application/json", "X-Mashape-Key":" OyaoPyoyPVmshHaiD8dc5CA9GJeCp12QsDKjsnWgTnZ5Aq3nQd"], parameters: ["apiKey":"b86dca21133b8411", "email" : searchTextField.text!])
            .validate().responseJSON() { response in
                switch response.result {
                case .Success:
                     //if the call is successful, do this
                    if let value = response.result.value {
                        let json = JSON(value)
                        // print(json)
                        
                        let data = json
                        

                        
                        //location
                        let demographics = data["demographics"]["locationDeduced"]["deducedLocation"].stringValue
                        print(demographics)
                        
                        //gender
                        let gender = data["demographics"]["gender"].stringValue
                        print(gender)
                        self.genderLabel.text = String(gender)
                        
                        //Person info
                        let name = data["contactInfo"]["fullName"]
                        self.nameLabel.text = String(name)
                        print(name)
//
//                        
                        
                        
                        
                        
//                       // MARK: loop social profiles
                        for (_, subJson) in json["socialProfiles"] {
                            
                            let newPhotoModelInstance = Photos()
                            
                            if let type = subJson["type"].string {
//                                print(type)
                                newPhotoModelInstance.social = type
                                print("The social network type value : \(newPhotoModelInstance.social) has been added")
                            } else {
                                
                                print("the 'type' value was not added")
                            }
                            
                        
                            if let username = subJson["username"].string {
//                                print(username)
                                newPhotoModelInstance.username = username
                                print("the username value: \(newPhotoModelInstance.username) was added")
                            } else {
                                    print("The 'username' value was not added")
                            }
                            
                            
                            if let url = subJson["url"].string {
//                                print(url)
                                newPhotoModelInstance.link = url
                                print("the url value : \(newPhotoModelInstance.link) has been added")
                            } else {
                                print("The 'url' value was not added")
                            }
                            
                            
                           
                            self.photosObjects.append(newPhotoModelInstance)


                            
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
                            
                            self.photosObjects.append(photoModelInstance)

                            
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
                                if placemarks?.count > 0 {
                                    let placemark = placemarks![0]
                                    
                                    //Annotation
                                    let annotation = MKPointAnnotation()
                                    annotation.title = "Target is here!"
                                    annotation.coordinate = (placemark.location?.coordinate)!
                                    
                                    //show the annotation
                                    self.theMapView.showAnnotations([annotation], animated: true)
                                    self.theMapView.selectAnnotation(annotation, animated: true)
                                }
                            }
                        }
                        
          
                      
                    }
                    //End of success .case
                case .Failure(let error):
                    print(error)
              
                }
                
                //Hide keyboard when finished editing
                self.view.endEditing(true)
            
        }
        
       
        
       

    }
    
    

  
    
    

   
    
  

    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    
    

//End of class
}
