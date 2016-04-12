//
//  WallClient.swift
//  Pondu
//
//  Created by Jonathan Green on 3/22/16.
//  Copyright © 2016 Jonathan Green. All rights reserved.
//

import Foundation
import UIKit
import SwiftEventBus

class WallClient {
    
    
     let user = KCSUser.activeUser()
    //let date = NSDate(timeIntervalSince1970: 1352149171)
    //let image = UIImage(named: "girl")
    let store = KCSLinkedAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "Wall",
        KCSStoreKeyCollectionTemplateClass : Wall.self
        ])
    
    var currentWall:[Wall] = []

    
    func post(theTitle:String,theDescription:String,theAddress:String,theLive:Bool,thelikes:Int,theDate:NSDate,theStartTime:NSDate,theEndTime:NSDate,thePrivacy:Bool,isEvent:Bool,theGeo:CLLocation){
        
        let profileImage = user.getValueForAttribute("ProfileImage") as! String
        
        print("user image \(profileImage)")
        
        let wall = Wall(theTitle: theTitle, theDescription: theDescription,theAddress: theAddress, theLive: theLive, thelikes: thelikes, theDate:theDate, theStartTime: theStartTime, theEndTime: theEndTime, thePrivacy: thePrivacy,isEvent:isEvent,theGeo:theGeo,theCreatedBy:user.username,theCreatorImage:profileImage)
        
        self.store.saveObject(
            wall,
            withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                if errorOrNil != nil {
                    //save failed
                    NSLog("Save failed, with error: %@", errorOrNil.localizedFailureReason!)
                } else {
                    //save was successful
                    NSLog("Successfully saved event (id='%@').", (objectsOrNil[0] as! NSObject).kinveyObjectId())
                    
                    SwiftEventBus.post("makeWall", sender: true)
                }
            },
            withProgressBlock: nil
        )
    }
    
    func getPost(){
        
        let collection = KCSCollection(fromString: "Wall", ofClass: NSDictionary.self)
        let wallStore = KCSCachedStore(collection: collection, options: [ KCSStoreKeyCachePolicy : KCSCachePolicy.LocalFirst.rawValue ])
        
        wallStore.queryWithQuery(
            KCSQuery(),
            withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                
                if errorOrNil != nil || objectsOrNil.count == 0 {
                    
                    print("the error \(errorOrNil)")
                    
                }else{
                    
                    print("we got \(objectsOrNil.count) objects")
                    
                    for  object:NSDictionary in objectsOrNil as! [NSDictionary] {
                        
                        let title = object.valueForKey("title") as? String
                        let address = object.valueForKey("address") as? String
                        let live = object.valueForKey("live") as? Bool
                        let likes = object.valueForKey("likes") as? Int
                        let date = object.valueForKey("date") as? NSDate
                        let startTime = object.valueForKey("startTime") as? NSDate
                        let endTime = object.valueForKey("endTime") as? NSDate
                        let privacy = object.valueForKey("privacy") as? Bool
                        let creator = object.valueForKey("createdBy") as? String
                        let geo = object.valueForKey("geocoord") as? CLLocation
                        
                        if let image = object.valueForKey("profileImage") as? String {
                            
                            self.getFile(image , completion: { (data) -> Void in
                                
                                print("the image is \(image)")
                                
                                let myEvent = Wall(theTitle: title!, theDescription: "", theAddress: address!, theLive: live!, thelikes: likes!, theDate: date!, theStartTime: startTime!, theEndTime: endTime!, thePrivacy: privacy!, isEvent: true, theGeo: geo!, theCreatedBy: creator!,theCreatorImage:String(data))
                                
                                print("the url to the image is \(myEvent.creatorImage)")
                                
                                self.currentWall.append(myEvent)
                                
                                
                            })
                        }
                        
                    }
                    
                    SwiftEventBus.post("MainWallEvent", sender: self.currentWall)
                }
                
            },
            withProgressBlock: nil
        )
    }
    
    func getFile(fileId:String,completion:(data:NSURL) -> Void){
        
        KCSFileStore.downloadFile(
            fileId,
            options: nil,
            completionBlock: { (downloadedResources: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    let file = downloadedResources[0] as! KCSFile
                    let fileURL = file.localURL
                    //let image = UIImage(contentsOfFile: fileURL.path!) //note this blocks for awhile
                    print("the url of the image \(file.remoteURL)")
                    
                    completion(data: file.remoteURL!)
                    
                } else {
                    NSLog("Got an error: %@", error)
                }
            },
            progressBlock: nil
        )
    }
}