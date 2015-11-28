//
//  WebServiceModel.swift
//  WhatToEat
//
//  This is a singleton class to handle all web service calls
//
//  Created by Spencer Smith on 11/25/15.
//  Copyright © 2015 Spencer Smith. All rights reserved.
//

import Foundation
import Alamofire


class WebServiceModel {
    static let sharedInstance = WebServiceModel();
    
    func getBarCodeInfo(aBarCode: String!, caller: UPCInfoViewController)
    {
        if let theUPC = aBarCode
        {

            let theURLAsString = "http://pod.opendatasoft.com/api/records/1.0/search?dataset=pod_gtin&q=gtin_cd%3D%22" + theUPC + "%22&facet=gpc_s_nm&facet=brand_nm&facet=owner_nm&facet=gln_nm&facet=prefix_nm"
            let theURL = NSURL(string: theURLAsString)
            let theURLSession = NSURLSession.sharedSession()
            let theJSONQuery = theURLSession.dataTaskWithURL(theURL!, completionHandler: {data, response, error -> Void in
                
                if(error != nil)
                {
                    print(error!)
                }
                
                do
                {
                    let theJSONResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                    if theJSONResult.count > 0
                    {
                        let theJSONArray = theJSONResult["records"] as? NSArray
                        if theJSONArray!.count > 0
                        {
                            if let theDictionary = theJSONArray![0]["fields"] as? NSDictionary
                            {
                                caller.showData(theDictionary["gtin_nm"] as? String, image: theDictionary["gtin_img"] as? String)
                            }
                        }
                        else {
                            caller.showData(nil, image: nil)
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
                
            })
            
            theJSONQuery.resume()

        }
    }
    
    func getGenericName(aBarCode: String!)
    {
        let apiEndPoint = "products"
        let apiUrl:String! = "https://api.semantics3.com/test/v1"
        let consumerKey:String! = "SEM33F110084D3A93B9A05634EA52C710497"
        let consumerSecret:String! = "NzkzMGZmYzQ5YjBmZjE2ZGYyMzY5Y2I3MWRjMmEzOTA"
        
        let params = ["api_key":"key"]
            
        Alamofire.request(.GET, "\(apiUrl)/\(apiEndPoint)", parameters: params)
                .authenticate(user: consumerKey, password: consumerSecret)
                .responseJSON { response in
                    print(response.request)
                    print(response.response)
                    print(response.data)
                    print(response.result)
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
            }
    }

}
