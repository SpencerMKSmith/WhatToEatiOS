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
    @IBOutlet weak var mAddItemButton: UIButton!
    
    var mItemName: String!
    var mImageData: NSData!
    var mItemNameGeneric: String!
    
    var mBarCode : String!
    var mJSONArray : NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        WebServiceModel.sharedInstance.getBarCodeInfo(mBarCode, caller: self)
    }
    
    func showData(name: String?, image: String?)
    {
        if let theName = name, let theImage = image
        {
            dispatch_async(dispatch_get_main_queue()){
                self.mNameLabel.text = theName
                let imageData = NSData(contentsOfURL : NSURL(string: theImage)!)
                self.mImageView.image = UIImage(data: imageData!)
                
                self.mItemName = theName
                self.mImageData = imageData
                self.mAddItemButton.hidden = false
            }
        } else {
            dispatch_async(dispatch_get_main_queue()){
                self.mNameLabel.text = "Product not found in database, please try a different product."
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func onAddItemButtonClick(sender: UIButton)
    {
        if !PantryData.sharedInstance.insertPantryItem(mItemName, image: mImageData)
        {
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        navigationController?.popToRootViewControllerAnimated(true)
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
