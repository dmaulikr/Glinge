//
//  PhotoViewController.swift
//  Glinge
//
//  Created by Kailash Ramaswamy Krishna Kumar on 10/13/15.
//  Copyright © 2015 Kailash Ramaswamy Krishna Kumar. All rights reserved.
//

import UIKit
import MessageUI
import Social

class PhotoViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    
    @IBOutlet weak var imaging: UIImageView!
    var image = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imaging.image = image

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sharePhoto(sender: AnyObject) {
        
        let actionS = UIAlertController(title: "Further action", message: "How would you like to proceed", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let mailer = UIAlertAction(title: "E-mail", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            if MFMailComposeViewController.canSendMail(){
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                
            mail.setSubject("Check out my Glinger")
                
                let imm = UIImagePNGRepresentation(self.image)
                
                mail.addAttachmentData(imm!, mimeType: "image/png", fileName: "Glinger")
                
                self.presentViewController(mail, animated: true, completion: nil)
                
            } else{
              self.alert("Mail not setup", message: "Please go to Settings and setup E-Mail to use this feature!")
            }
            
        }
        
        let tweeter = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default) { (ACTION) -> Void in
            
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
               let tweet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                
                tweet.title = "Check out my Glinger"
                
                tweet.addImage(self.image)
                
                self.presentViewController(tweet, animated: true, completion: nil)
            } else{
                
            self.alert("Twitter not setup", message: "Please go to Settings -> Setup Twitter profile to use this feature!")
            }
            
        }
        
        let facer = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.Default) { (action) -> Void in
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
                let fb = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                fb.title = "Check out my Glinger"
                
                fb.addImage(self.image)
                
                self.presentViewController(fb, animated: true, completion: nil)
            } else {
                self.alert("Facebook not setup", message: "Please go to Settings and setup Facebook profile to use this feature!")
            }
            
            
        }
        
        let save = UIAlertAction(title: "Save Photo", style: UIAlertActionStyle.Default) { (action) -> Void in
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil)
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            self.alert("Image saved successfully", message: "Yay")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        actionS.addAction(tweeter)
        
         actionS.addAction(mailer)
        
        actionS.addAction(facer)
        
        actionS.addAction(save)
        
        actionS.addAction(cancel)
        
        presentViewController(actionS, animated: true, completion: nil)
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func alert(title:String, message: String){
        let al = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alac = UIAlertAction(title: "Okay!", style: UIAlertActionStyle.Cancel, handler: nil)
        
        al.addAction(alac)
        
        self.presentViewController(al, animated: true, completion: nil)
        
    }
}
