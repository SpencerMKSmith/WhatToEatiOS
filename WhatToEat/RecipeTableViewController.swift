//
//  RecipesTableViewController.swift
//  WhatToEat
//
//  Created by Spencer Smith on 11/14/15.
//  Copyright © 2015 Spencer Smith. All rights reserved.
//

import UIKit
import CoreData

class RecipesTableViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var mTableView: UITableView!
    
    var mRecipes: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return mRecipes!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.mTableView.dequeueReusableCellWithIdentifier("dataCell", forIndexPath: indexPath)
        let theRecipe = mRecipes![indexPath.row] as! NSDictionary
        let recipeName = theRecipe["title"] as! String
        let recipeImage = theRecipe["image_url"] as! String
        let imageData = NSData(contentsOfURL : NSURL(string: recipeImage)!)

        cell.textLabel?.text = recipeName
        cell.imageView?.image = UIImage(data: imageData!)
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "toRecipeInfoSegue")
        {
            if let recipeInfoViewController: RecipeInfoViewController = segue.destinationViewController as? RecipeInfoViewController
            {
                let selectedIndex: NSIndexPath = self.mTableView.indexPathForCell( sender as! UITableViewCell )!
                let theRecipe = mRecipes![selectedIndex.row] as! NSDictionary
                let theRecipeId = theRecipe["recipe_id"]
                recipeInfoViewController.mRecipeData
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
