//
//  UPCInfoViewController.swift
//  WhatToEat
//
//  This View Controller will take the barcode number that is passed to it from the
//      scanner and uses a web service to get the product information that coresponds
//      to the EAN number.
//
//  TODO: Figure out how to use OAuth authorization to be able to use the Semantics3.com API
//        to get the general name of a product, whereas right now all I can get from the API
//        is the name of the product.
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
    
    var mItemName: String?
    var mImageData: NSData?
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
                if imageData != nil
                {
                    self.mImageView.image = UIImage(data: imageData!)
                    self.mImageData = imageData
                } 
                
                self.mItemName = theName
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
        if !PantryData.sharedInstance.insertPantryItem(mItemName!, image: mImageData)
        {
            let alert = UIAlertController(title: "Duplicate", message: "This item is already in your pantry.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func showNoInternetDialogue()
    {
        let alert = UIAlertController(title: "No Internet", message: "WARNING: I detect that you are not connected to the internet or you are connected to a network that doesn't support the webservice calls that I use.  Please connect to another network. \n (I usually tether to my phone)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
