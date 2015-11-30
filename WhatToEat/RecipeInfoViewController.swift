//
//  RecipeInfoViewController.swift
//  WhatToEat
//
//  This view controller will show a big picture of the dish that is to be made, and a list
//      of all of the ingredients that are needed to make it.  Also, the first element in the
//      table view is a button that will take the user to the full recipe showing how to make
//      the dish.
//
//  TODO: Improve the UI, possibly add scrolling to the view and make the button look better.
//
//  Created by Spencer Smith on 11/16/15.
//  Copyright © 2015 Spencer Smith. All rights reserved.
//

import UIKit

class RecipeInfoViewController: UIViewController {

    var mIngredients: [String] = []
    var mImage: UIImage?
    var mURL: String?
    
    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var mTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = mImage
        {
            mImageView.image = image
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mIngredients.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell = self.mTableView.dequeueReusableCellWithIdentifier("buttonCell", forIndexPath: indexPath)
            return cell
        } else {
            let cell = self.mTableView.dequeueReusableCellWithIdentifier("dataCell", forIndexPath: indexPath)
            cell.textLabel?.text = mIngredients[indexPath.row - 1]
            return cell
        }
        
    }
    
    func setRecipeInfo(recipeData: NSDictionary)
    {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        
            self.mIngredients = recipeData["ingredients"] as! [String]
            self.title = recipeData["title"] as? String
            self.mTableView.reloadData()
            self.mURL = recipeData["source_url"] as? String
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "toWebViewSegue"
        {
            if let webViewController: WebViewController = segue.destinationViewController as? WebViewController
            {
                    webViewController.mURL = mURL
            }
        }
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
