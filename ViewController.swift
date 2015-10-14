//
//  ViewController.swift
//  Glinge
//
//  Created by Kailash Ramaswamy Krishna Kumar on 10/13/15.
//  Copyright © 2015 Kailash Ramaswamy Krishna Kumar. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var thirdView: UIImageView!
    @IBOutlet weak var SecondView: UIImageView!
    @IBOutlet weak var mainView: UIImageView!
    @IBOutlet weak var pre2: UILabel!
    @IBOutlet weak var pre1: UILabel!
    let cameraSession = AVCaptureSession()
    
    var classy = 0
    
    var backCamera:AVCaptureDevice?
    
    var frontCamera:AVCaptureDevice?
    
    var currentDevice: AVCaptureDevice?
    
    var stillImageOutput: AVCaptureStillImageOutput?
    
    var stillImage: UIImage?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var cameraToggler: UISwipeGestureRecognizer?
    
    var cameraTogglerBack: UISwipeGestureRecognizer?
    
    var filterOn: Bool = false
    
    var newImage =  UIImage()
    
    var result = UIImage()
    
    var filterIn : UISwipeGestureRecognizer?
    
    var filterOut: UISwipeGestureRecognizer?
    
    var glee: NSMutableArray = ["star.png","rainbow.png"]
    

    @IBOutlet weak var captureButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
  
        
        mainView.alpha = 0
        SecondView.alpha = 0
        thirdView.alpha = 0
        
        captureButton.layer.cornerRadius = captureButton.bounds.width/2
        
        captureButton.layer.borderWidth = 2.0
        
        captureButton.layer.borderColor = UIColor.blackColor().CGColor
        
        cameraSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        
        for device in devices {
            if device.position == AVCaptureDevicePosition.Back{
                
               backCamera = device
            } else if device.position == AVCaptureDevicePosition.Front{
                
                frontCamera = device
            }
            
        }
        
        currentDevice = backCamera
        
        let currentInput = try! AVCaptureDeviceInput(device: currentDevice)
        
        stillImageOutput = AVCaptureStillImageOutput()
        
        stillImageOutput!.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        
        cameraSession.addInput(currentInput)
        
        cameraSession.addOutput(stillImageOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: cameraSession)
        
        view.layer.addSublayer(previewLayer!)
        
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        previewLayer?.frame  = self.view.layer.frame
        
        view.bringSubviewToFront(captureButton)
        
        cameraSession.startRunning()
        
        cameraToggler = UISwipeGestureRecognizer()
        
        cameraToggler?.direction = .Up
        
        cameraTogglerBack = UISwipeGestureRecognizer()
        
        cameraTogglerBack?.direction = .Down
        
        cameraToggler?.addTarget(self, action: "switchCamera")
        
        cameraTogglerBack?.addTarget(self, action: "switchCamera")
        
        filterIn = UISwipeGestureRecognizer()
        
        filterIn?.direction = .Right
        
        filterIn?.addTarget(self, action: "bringFilter")
        
        filterOut = UISwipeGestureRecognizer()
        
         filterOut?.direction = .Left
        
        filterOut?.addTarget(self, action: "removeFilter")
        
        view.addGestureRecognizer(filterIn!)
        
        view.addGestureRecognizer(filterOut!)
        
        view.addGestureRecognizer(cameraToggler!)
        
        view.addGestureRecognizer(cameraTogglerBack!)
        
        

        mainView.image = UIImage(named:"starry.png")

        SecondView.image = UIImage(named:"rainy.png")
        
        thirdView.image = UIImage(named: "moustache.png")

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        pre1.alpha = 1
        pre2.alpha = 1
    
        view.bringSubviewToFront(pre1)
        view.bringSubviewToFront(pre2)
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "updateIT", userInfo: nil, repeats: true)
        
    }
    
    func updateIT(){
        self.pre1.alpha = 0
        
        self.pre2.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func captureImage(sender: AnyObject) {
    
        let videoConn = self.stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo)
        
        self.stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConn, completionHandler: { (action, error) -> Void in
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(action)
            
            self.stillImage = UIImage(data: imageData)
            
            self.newImage = self.stillImage!
            
          if self.filterOn == false {
            
            self.performSegueWithIdentifier("showPhoto", sender: self)
            
        }
         else {
            self.screenshot()
            
            }
        })
    }
    
    func screenshot(){
        UIGraphicsBeginImageContext(CGSizeMake(self.view.layer.bounds.width, self.view.layer.bounds.height))
        self.newImage.drawInRect(CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        
        if filterOn == false {
            print("No filter")
        } else {
            if mainView.alpha == 1 {
            self.mainView.image?.drawInRect(CGRectMake(0, 0, self.mainView.bounds.width, self.mainView.bounds.height))
            } else if SecondView.alpha == 1 {
                self.SecondView.image?.drawInRect(CGRectMake(0, 0, self.SecondView.bounds.width, self.SecondView.bounds.height))
            } else if thirdView.alpha == 1 {
                self.thirdView.image?.drawInRect(CGRectMake(0, 0, self.thirdView.bounds.width, self.thirdView.bounds.height))
            }
        }
        
        self.result = UIGraphicsGetImageFromCurrentImageContext()
            
        UIGraphicsEndImageContext()
    
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            self.performSegueWithIdentifier("showPhoto", sender: self)
        }
    }
    
    
    func switchCamera(){
        cameraSession.beginConfiguration()
        
        let newDevice = (currentDevice?.position == AVCaptureDevicePosition.Back) ? frontCamera: backCamera
        
        for input in cameraSession.inputs {
           cameraSession.removeInput(input as! AVCaptureInput)
        }
        
        let newInput = try! AVCaptureDeviceInput(device: newDevice)
        
        if cameraSession.canAddInput(newInput){
        cameraSession.addInput(newInput)
        }
        
        currentDevice = newDevice
        
        cameraSession.commitConfiguration()
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPhoto"{
            
            let photoViewController = segue.destinationViewController as! PhotoViewController
            if filterOn == false {
            photoViewController.image = stillImage!
            } else if filterOn == true {
                
                photoViewController.image = result
            }
    }
    
    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
    
    
    func bringFilter(){
        if filterOn == false {
           
            mainView.alpha = 1
            
            view.bringSubviewToFront(mainView)
            
            filterOn = true
            
        } else if filterOn == true && SecondView.alpha == 0 {
    
            
            mainView.alpha = 0
            
            if thirdView.alpha == 0 {
                
            SecondView.alpha = 1
  
            view.bringSubviewToFront(SecondView)
            
            } else {
                 alert("Oops!, That's all the FunFilters we have at the moment", message: "We are working on new ones, expect great new updates soon!")
            }
          
            
        } else if filterOn == true && SecondView.alpha == 1 {
           
            SecondView.alpha = 0
            
            thirdView.alpha = 1
            
            view.bringSubviewToFront(thirdView)
            
        } else if filterOn == true && thirdView.alpha == 1 {
            
            alert("Oops!, That's all the FunFilters we have at the moment", message: "We are working on new ones, expect great new updates soon!")
        }
      
    }
    
    func removeFilter(){
      
        if filterOn == true {
            if thirdView.alpha == 1 {
             thirdView.alpha = 0
                view.sendSubviewToBack(thirdView)
                view.bringSubviewToFront(SecondView)
                
                SecondView.alpha = 1
                
            }else if SecondView.alpha == 1{
                 SecondView.alpha = 0
                view.sendSubviewToBack(SecondView)
                
                view.bringSubviewToFront(mainView)
                mainView.alpha = 1
            } else if mainView.alpha == 1{
                mainView.alpha = 0
                view.sendSubviewToBack(mainView)
                filterOn = false
            }
            
        } else if filterOn == false {
            
        alert("You are on Screen 1", message: "Swipe Right to activate your favorite FunFilter, swipe Left to return to Screen 1")
        
        }
        
  

    }
    func alert(title:String, message: String){
        let al = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alac = UIAlertAction(title: "Okay!", style: UIAlertActionStyle.Cancel, handler: nil)
        
        al.addAction(alac)
        
        self.presentViewController(al, animated: true, completion: nil)
        
    }

}