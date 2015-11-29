//
//  ViewController.swift
//  WhatToEat
//
//  Created by Spencer Smith on 11/14/15.
//  Copyright © 2015 Spencer Smith. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    var mRecipes: [NSDictionary] = []
    @IBOutlet weak var mRecipesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewDidAppear(animated)

        let PantryItems = PantryData.sharedInstance.getPantryItems() as! [PantryItem]
        for (index, theItem) in PantryItems.enumerate()
        {
            let image = UIImage(data: theItem.image!)
            let imageView = UIImageView(image: image!)
            let coordinates = getViewCoordinates(index)
            imageView.frame = CGRect(x: coordinates.x, y: coordinates.y, width:50, height:50)
            view.addSubview(imageView)
        }
        mRecipes.removeAll() //Reset the recipes so they aren't duplicated
        WebServiceModel.sharedInstance.getRecipes(self) //Stores the recipes in mRecipes to pass to the table view when clicked on by user
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //This function takes in an index and returns the coordinates of where
    //      the image view should be placed in the pantry.
    func getViewCoordinates(index: Int) -> (x: Double, y: Double) {
        switch index {
        case 0: return (x: 112, y: 250)
        case 1: return(109.5, 121.5)
        case 2: return(256.5, 244.5)
        case 3: return(6, 93)
        case 4: return(32,240)
        case 5: return(260.5, 96)
        case 6: return(54.5, 385)
        case 7: return(190.5, 380.5)
        case 8: return(203.5,104)
        case 9: return(207,238.5)
        case 10: return(148.5,342.5)
        case 11: return(140,416)
        case 12: return(153.5,507)
        default: return (100, 100)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "toRecipeTableSegue"
        {
            if let nextViewController: RecipesTableViewController = segue.destinationViewController as? RecipesTableViewController
            {
                nextViewController.mRecipes = mRecipes
            }
        }
    }
    
    func enableRecipeButton()
    {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.mRecipesButton.enabled = true
            self.mRecipesButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        })
    }
}
