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

    //This function will loop through each item in the pantry and query if there is a recipe
    //      that takes the item as an ingredient.  Is will add each of these to the mRecipes array that lives
    //      in the ViewController.
    func getRecipes(caller: ViewController)
    {
        let thePantryItems = PantryData.sharedInstance.getPantryItems() as? [PantryItem]

        for (index, item) in (thePantryItems?.enumerate())!
        {
            let fixedName = fixName(item.name!)
            let theURLAsString = "http://food2fork.com/api/search?key=cc1044d1367fc612bad102715c897a5c&q=" + fixedName
            let theURL = NSURL(string: theURLAsString)
            let theURLSession = NSURLSession.sharedSession()
            
            let theJSONQuery = theURLSession.dataTaskWithURL(theURL!, completionHandler: { data, response, error -> Void in
                
                if(error != nil)
                {
                    print(error!)
                }
                
                do
                {
                    let theJSONResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    if theJSONResult.count > 0
                    {
                        let theJSONArray = theJSONResult["recipes"] as? [NSDictionary]
                        for var i = 0; (i < theJSONArray!.count) && (i < 10); i++
                        {
                            let theRecipe = theJSONArray![i]
                            caller.mRecipes.append(theRecipe)
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
                
                if index == (thePantryItems?.count)! - 1
                {
                    caller.enableRecipeButton()
                }
            })
            theJSONQuery.resume()
        }
    }
    
    func getRecipeByID(recipeId: String, sendTo: RecipeInfoViewController)
    {
        let theURLAsString = "http://food2fork.com/api/get?key=cc1044d1367fc612bad102715c897a5c&rId=" + recipeId
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
                    let theRecipeDictionary = theJSONResult["recipe"] as? NSDictionary
                    sendTo.setRecipeInfo(theRecipeDictionary!)
                }
            } catch let error as NSError {
                print(error)
            }
        })
        theJSONQuery.resume()
    }

    
    }

    func fixName(name: String) -> String
    {
        let returnString = name.stringByReplacingOccurrencesOfString(" ", withString:"%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        return returnString
    }


