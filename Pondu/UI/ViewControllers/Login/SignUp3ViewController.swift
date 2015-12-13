//
//  SignUp3ViewController.swift
//  Pondu
//
//  Created by Jonathan Green on 12/8/15.
//  Copyright © 2015 Jonathan Green. All rights reserved.
//

import UIKit
import ImagePickerSheetController
import Photos
import SwiftSpinner
import SwiftEventBus
import BubbleTransition
import Alamofire

class SignUp3ViewController: UIViewController,UIViewControllerTransitioningDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate{
    
    let segueID = "Home"
    
    let newAccount = SignUP()
    let transition = BubbleTransition()
    let client:college = college()
    
    var username:String!
    var password:String!
    var email:String!
    var fullName:String!
    var image:UIImage!
    
    var schools:[School] = []

    @IBOutlet weak var pickerView: UIPickerView!
  
    @IBOutlet weak var pickSchool: UIButton!
    @IBOutlet weak var graduation: UITextField!
    @IBOutlet weak var next: UIButton!
    
    @IBAction func nextBtn(sender: AnyObject) {
        
        createUser()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftEventBus.onMainThread(self, name:"school") { (result) -> Void in
            
            self.schools = result.object as! [School]
            
            self.pickerView.reloadAllComponents()
            
        }
        
        transition.duration = 0.4
        
        graduation.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        graduation.resignFirstResponder()
       
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickSchoolBtn(sender: AnyObject) {
        
        
        self.schools = []
        
        self.pickerView.reloadAllComponents()

        
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Search",
            message: "Entered Shool Name",
            preferredStyle: .Alert)
        
        
        alertController!.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.placeholder = "School Name"
        })
        
        let action = UIAlertAction(title: "Search",
            style: UIAlertActionStyle.Default,
            handler: {[weak self]
                (paramAction:UIAlertAction!) in
                if let textFields = alertController?.textFields{
                    let theTextFields = textFields as [UITextField]
                    let enteredText = theTextFields[0].text
                    self!.client.getData(enteredText!)
                    print("Entered Shool Name \(enteredText)")
                    
                    //self!.displayLabel.text = enteredText
                }
            })
        
        
    
        alertController?.addAction(action)
        self.presentViewController(alertController!,
            animated: true,completion:{
                
                
        })
        
        self.pickerView.reloadAllComponents()
    }
    

    
    func createUser(){
        
        let placeholder = UIImage(named: "placeholder")
        
        SwiftEventBus.onMainThread(self, name: "SignUpSucess") { (result) -> Void in
            
            SwiftSpinner.hide({
                
                self.performSegueWithIdentifier(self.segueID, sender: self)
                
            })
        }
        
        if graduation.text != "" && pickSchool.titleLabel?.text != "Pick Your School"  {
            
            SwiftSpinner.show("Uploading Image...")
            
            newAccount.AccounSetup("",fullName:fullName,userName:username,password:password,Bio:"",email:email,phone:"",photo:image!,stories:image!,theYear:graduation.text!,theSchool:(pickSchool.titleLabel?.text)! )
            
            print(username)
            print(password)
            print(email)
            print(fullName)
            print(pickSchool.titleLabel?.text)
    }
}
    
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return schools.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return schools[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickSchool.setTitle(schools[row].name, forState: UIControlState.Normal)
    }

    
        func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            transition.transitionMode = .Present
            transition.startingPoint = self.view.center
            transition.bubbleColor = UIColor.whiteColor()
            return transition
        }
        
        
        func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            transition.transitionMode = .Dismiss
            transition.startingPoint = self.view.center
            transition.bubbleColor = UIColor.blueColor()
            return transition
        }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == segueID {
            
            let controller = segue.destinationViewController
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .Custom
            
        }
        
    }
    

}
