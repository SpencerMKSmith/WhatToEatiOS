//
//  ScanViewController.swift
//  WhatToEat
//
//  Created by Spencer Smith on 11/14/15.
//  Copyright © 2015 Spencer Smith. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var mLabel : UILabel!
    
    let session = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var  identifiedBorder : DiscoveredBarCodeView?
    var timer : NSTimer?
    var mFoundBarCode: String?
    
    /* Add the preview layer here */
    func addPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.bounds = self.view.bounds
        previewLayer?.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
        self.view.layer.addSublayer(previewLayer!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do{
            let inputDevice = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput?
            
            if let inp = inputDevice {
                session.addInput(inp)
            }
            
            addPreviewLayer()
            
            identifiedBorder = DiscoveredBarCodeView(frame: self.view.bounds)
            identifiedBorder?.backgroundColor = UIColor.clearColor()
            identifiedBorder?.hidden = true;
            self.view.addSubview(identifiedBorder!)
            
            
            /* Check for metadata */
            let output = AVCaptureMetadataOutput()
            session.addOutput(output)
            output.metadataObjectTypes = output.availableMetadataObjectTypes
            print(output.availableMetadataObjectTypes)
            output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            
            session.startRunning()
        } catch let error as NSError {
            print(error)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        session.stopRunning()
    }
    
    func translatePoints(points : [AnyObject], fromView : UIView, toView: UIView) -> [CGPoint] {
        var translatedPoints : [CGPoint] = []
        for point in points {
            let dict = point as! NSDictionary
            let x = CGFloat((dict.objectForKey("X") as! NSNumber).floatValue)
            let y = CGFloat((dict.objectForKey("Y") as! NSNumber).floatValue)
            let curr = CGPointMake(x, y)
            let currFinal = fromView.convertPoint(curr, toView: toView)
            translatedPoints.append(currFinal)
        }
        return translatedPoints
    }
    
    func startTimer() {
        if timer?.valid != true {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "removeBorder", userInfo: nil, repeats: false)
        } else {
            timer?.invalidate()
        }
    }
    
    func removeBorder() {
        /* Remove the identified border */
        self.identifiedBorder?.hidden = true
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for data in metadataObjects {
            let metaData = data as! AVMetadataObject
            let transformed = previewLayer?.transformedMetadataObjectForMetadataObject(metaData) as? AVMetadataMachineReadableCodeObject
            if let unwraped = transformed {
                mFoundBarCode = unwraped.stringValue
                performSegueWithIdentifier("ScanToUPCInfoSegue", sender: nil)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ScanToUPCInfoSegue"
        {
            if let nextViewController: UPCInfoViewController = segue.destinationViewController as? UPCInfoViewController
            {
                self.session.stopRunning()
                nextViewController.mBarCode = mFoundBarCode
            }
        }
    }
}
