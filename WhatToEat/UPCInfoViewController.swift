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

        WebServiceModel.sharedInstance.getBarCodeInfo(mBarCode, caller: self)
        
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
            dispatch_async(dispatch_get_main_queue()){
                self.mNameLabel.text = (theDictionary!["gtin_nm"] as! String)
            
                let url = NSURL(string: theDictionary!["gtin_img"] as! String)
                let data = NSData(contentsOfURL:url!)
                self.mImageView.image = UIImage(data: data!)
            }
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
