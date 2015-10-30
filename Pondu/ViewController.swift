//
//  ViewController.swift
//  Pondu
//
//  Created by Jonathan Green on 10/25/15.
//  Copyright © 2015 Jonathan Green. All rights reserved.
//

import UIKit
import SwiftEventBus

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let mainWall = PresentMainWall()
    let Parties = PartiesMainWall()
    let user = users()
    let newAccount = SignUP()
    let userLogin = startLogin()
    let favorite = userFavorites()
    let favParty = partyFavorites()
    let eventID:[String] = []
    var count:Int = 0
    var array:[String] = []
    
    @IBOutlet weak var tablview: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        
        //mainWall.eventPost()
        //mainWall.eventIcon()
        //mainWall.eventThumb()
        //mainWall.eventCL()
        //mainWall.eventCM()
        //mainWall.profileName()
        //mainWall.eventAddress()
        //user.userBio()
        //user.userStory()
        //user.userFullName()
        //user.userNames()
        //user.userArea()
        //user.userPhoto()
        //Parties.partiesPost()
        favParty.getFavorite()
        //newAccount.AccounSetup(area:String,fullName:String,userName:String,password:String,Bio:String,email:String,phone:String,photo:UIImage,stories:UIImage)
        //userLogin.beginLogin(<#T##UserName: String##String#>, password: <#T##String#>)
        
        //mainWall.eventID(eventID )
        //favorite.addFavorite(0)
        //getArrayCount()
        
        //favorite.getFavorite()
        //mainWall.eventPost()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getArrayCount()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return array.count
    }
    
  
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:MainCell = tableView.dequeueReusableCellWithIdentifier("MainCell", forIndexPath: indexPath) as! MainCell
        
        cell.post.text = array[indexPath.row]
        
        return cell
    }
    
    func getArrayCount(){
        
        SwiftEventBus.onMainThread(self, name: "updateCell") { notification in
            //self.textField.text = "\(self.count)"
            
            print("passing data\(notification.object)")
            
            self.array = notification.object as! [String]
            
            print(self.array.count)
            
            self.tablview.reloadData()
            
        }
    }

}

