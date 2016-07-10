//
//  PasswordCheckerVC.swift
//  Security.me
//
//  Created by Kenny Batista on 7/7/16.
//  Copyright © 2016 Kenny Batista. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PasswordCheckerVC: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resultsLabel: UILabel!
    
    
  


    @IBAction func checkButton(sender: UIButton) {
        
        if passwordTextField.text != nil {
        Alamofire.request(.GET, "https://pwd.p.mashape.com/verify", headers: [ "Content-Type": "application/json",
            "X-Mashape-Key": "OyaoPyoyPVmshHaiD8dc5CA9GJeCp12QsDKjsnWgTnZ5Aq3nQd"], parameters: ["password" : passwordTextField.text!])
            .validate().responseJSON() { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        // Do what you need to with JSON here!
                        // The rest is all boiler plate code you'll use for API requests
                        let userData = json
                        
                        let passwordChecked = userData["data"]["password"].stringValue
                        let timesHacked = userData["data"]["score"].stringValue
                     
                        
                        if timesHacked < String(0) {
                            self.resultsLabel.text = "Safe! Your password '" + passwordChecked + "' has not been hacked."
                        } else {
                            self.resultsLabel.text =  "Not safe! Your password '" + passwordChecked + "' has been hacked and redistributed " + timesHacked + " times."
        
                                                       }
                    }
                case .Failure(let error):
                    print(error)
                }
            }
        } else {
            print("Empty Field, please type!")
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
    }
    
    
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
