//
//  UPCInfoViewController.swift
//  WhatToEat
//
//  Created by Spencer Smith on 11/14/15.
//  Copyright © 2015 Spencer Smith. All rights reserved.
//

import UIKit
import Foundation

class UPCInfoViewController: UIViewController {

    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var mNameLabel: UILabel!
    
    var mBarCode : String!
    var mJSONArray : NSArray?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let theUPC = mBarCode
        {
            let theURLAsString = "http://pod.opendatasoft.com/api/records/1.0/search?dataset=pod_gtin&q=gtin_cd%3D%22" + theUPC + "%22&facet=gpc_s_nm&facet=brand_nm&facet=owner_nm&facet=gln_nm&facet=prefix_nm"
            let theURL = NSURL(string: theURLAsString)
            let theURLSession = NSURLSession.sharedSession()
            let theJSONQuery = theURLSession.dataTaskWithURL(theURL!, completionHandler: {data, response, error -> Void in
                
                if(error != nil)
                {
                    print(error!.localizedDescription)
                }
                
                self.parseThisData(data!)

            })
            
            theJSONQuery.resume()
        }
        // Do any additional setup after loading the view.
    }
    
    func parseThisData(data: NSData)
    {
        do{
            let theJSONResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            mJSONArray = theJSONResult["records"] as? NSArray
            let theDictionary = mJSONArray![0]["fields"] as? NSDictionary
            print("TESTTTTTTTT")
            print(theDictionary!["gtin_img"])
            print(theDictionary!["gtin_nm"])
            mNameLabel.text = theDictionary!["gtin_nm"] as! String
            
            let url = NSURL(string: theDictionary!["gtin_img"] as! String)
            let data = NSData(contentsOfURL:url!)
            self.mImageView.image = UIImage(data: data!)
        } catch let error as NSError {print(error)}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
