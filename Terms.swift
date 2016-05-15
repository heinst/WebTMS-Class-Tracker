//
//  Terms.swift
//  Class Tracker
//
//  Created by Trevor Heins on 12/18/15.
//  Copyright © 2015 Trevor Heins. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

class Terms: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Alamofire.request(.GET, "https://duapp2.drexel.edu/webtms_du/app")
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

