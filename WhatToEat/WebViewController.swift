//
//  WebViewController.swift
//  WhatToEat
//
//  Created by Spencer Smith on 11/28/15.
//  Copyright © 2015 Spencer Smith. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    var mURL: String?
    @IBOutlet weak var mWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let requestURL = NSURL(string: mURL!)
        let request = NSURLRequest(URL: requestURL!)
        mWebView.loadRequest(request)
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
