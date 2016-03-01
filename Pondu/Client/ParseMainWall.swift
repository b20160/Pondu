//
//  ParseMainWall.swift
//  Pondu
//
//  Created by Jonathan Green on 10/25/15.
//  Copyright © 2015 Jonathan Green. All rights reserved.
//

import UIKit
import SwiftEventBus
import Parse

class ParseMainWall {
    
    static let sharedInstance = ParseMainWall()
    
    var mainWallID:[String] = []
    
    let currentUser = PFUser.currentUser()
    
    func postQuery(){
        
        var wall:[Event] = []
        var comment:[Comment] = []
        var liveContent:[Content] = []
        var objects:[PFObject]!
        var eventObjects:[PFObject]!
        var commentObjects:[PFObject]!
        
        let query = PFQuery(className: "Events")
        
        do {
            
            try objects = query.findObjects()
            
        }catch _ {
            
        }
        
        if let objects = objects {
            
            for object in objects {
                
                let relation = object.relationForKey("Events")
                let eventQuery = relation.query()
                
                
                do {
                    
                    try eventObjects = eventQuery?.findObjects()
                    
                }catch _{
                    
                }
                
                if let eventObjects = eventObjects {
                    
                    print("got main wall \(eventObjects.count)")
                    
                    for event in eventObjects {
                        
                        print("got main wall \(event.objectId)")
                        
                        guard let theID = event.objectId else {
                            
                            return
                        }
                        guard let post:String = event.objectForKey("Post") as! String! else {
                            
                            return
                        }
                        guard let profileName:String = event.objectForKey("Name") as! String! else {
                            
                            return
                        }
                        guard let createdBy:PFUser = event.objectForKey("CreatedBy") as? PFUser else {
                            
                            return
                        }
                        guard let profileImage:PFFile = createdBy.objectForKey("photo") as? PFFile else {
                            
                            return
                        }
                        guard let userName = createdBy.username else {
                            
                            return
                        }
                        guard let comments:PFObject = event.objectForKey("Comments") as? PFObject else {
                            
                            return
                        }
                        guard let content:PFObject = event.objectForKey("LiveContent") as? PFObject else {
                            
                            return
                        }
                        
                        guard let contentData:PFRelation = content.relationForKey("Content") else {
                            
                            return
                        }
                        
                        guard let contentQuery = contentData.query() else {
                            
                            return
                        }
                        
                        guard let commentsData:PFRelation = comments.relationForKey("Comments") else {
                            
                            return
                        }
                        
                        let commentQuery = commentsData.query()
                        
                        
                        print("the Event is firing \(post)")
                        
                        let theEvent = Event(theID: theID, theName: profileName,theUserName:userName, thePost: post, TheProfilePicture: profileImage.url!,theComments:comment,theContent:liveContent)
                        
                        wall.append(theEvent)
                        
                        print("number of media items \(liveContent.count) ")
                        
                        do {
                            try commentObjects = commentQuery?.findObjects()
                            
                        }catch _{
                            
                        }
                        
                        if let commentObjects = commentObjects {
                            
                            for commentObject in commentObjects {
                                
                                guard let createdBy:PFUser = commentObject.objectForKey("CreatedBy") as? PFUser else {
                                    
                                    return
                                }
                                guard let userImage:PFFile = createdBy["photo"] as? PFFile else {
                                    
                                    return
                                }
                                guard let description:String = commentObject.objectForKey("Description") as? String else {
                                    
                                    return
                                }
                                
                                guard let date = object.createdAt else {
                                    
                                    return
                                }
                                
                                let commentInfo:Comment = Comment(theDescription: description, theCreatorImage: userImage.url!, theCreatorName: createdBy.username!, theTime: date)
                                
                                comment.append(commentInfo)
                            }
                            
                        }
                        
                        
                        
                    }
                    
                    
                    print("sending \(objects.count) events")
                    
                    SwiftEventBus.post("MainWallEvent", sender: wall)
                    
                    
                    
                    
                } else {
                    
                    
                }
                
                }
            
            }
}

    func comments(objectId:String){
        
        var data:[Comment] = []
        let query = PFQuery(className: "MainWall")
        query.getObjectInBackgroundWithId(objectId) { (object, error) -> Void in
            
            if let object = object {
                
                let comment = object.objectForKey("Comments") as! PFObject
                
                let relation = comment.relationForKey("Comments")
                
                let commentQuery = relation.query()
                
                commentQuery?.orderByDescending("createdAt")
                commentQuery?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    
                    if let objects = objects {
                        
                        for object in objects {
                            
                            let description = object.objectForKey("Description") as! String
                            let createdBy = object.objectForKey("CreatedBy") as! PFUser
                            let userImage = createdBy.objectForKey("photo") as! PFFile
                            let userName = createdBy.username
                            let time = object.createdAt
                            
                            let theComment = Comment(theDescription: description, theCreatorImage: userImage.url!, theCreatorName: userName!, theTime: time!)
                            
                            data.append(theComment)
                            print(description)
                        }
                        
                        
                        SwiftEventBus.post("EventComments", sender: data)
                    }
                })
            }
        }
    }
    
    func liveContent(objectId:String){
        
        
        var data:[String] = []
        let query = PFQuery(className: "MainWall")
        query.getObjectInBackgroundWithId(objectId) { (object, error) -> Void in
            
            if let object = object {
                
                let content = object.objectForKey("LiveContent") as! PFObject
                
                let relation = content.relationForKey("Content")
                
                let contentQuery = relation.query()
                
                contentQuery?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    
                    if let objects = objects {
                        
                        for object in objects {
                            
                            let media = object.objectForKey("Media") as! PFFile
                            
                            data.append(media.url!)
                            print(media.url)
                        }
                        
                        
                        SwiftEventBus.post("EventContent", sender: data)
                    }
                })
            }
        }
    }
    
    func favEvents(){
        
        let relation = currentUser?.relationForKey("FavEvents")
        let query = relation?.query()
        
        var wall:[Event] = []
        var comment:[Comment] = []
        var liveContent:[Content] = []
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            print("boom \(objects?.count)")
            
            if let objects = objects {
                
                for object in objects {
                    
                    
                    let event = object.objectForKey("FavEvents") as! PFObject
                    let theID = event.objectId
                    let post = event.objectForKey("Post") as! String!
                    let profileName = event.objectForKey("Name") as! String!
                    let createdBy = event.objectForKey("CreatedBy") as! PFUser
                    let profileImage = createdBy.objectForKey("photo") as! PFFile
                    let userName = createdBy.username
                    let comments = event.objectForKey("Comments") as! PFObject
                    let content = event.objectForKey("LiveContent") as! PFObject
                    
                    let contentData = content.relationForKey("Content")
                    
                    let contentQuery = contentData.query()
                    
                    let commentsData = comments.relationForKey("Comments")
                    
                    let commentQuery = commentsData.query()
                    
                    commentQuery?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        
                        if let objects = objects {
                            
                            for object in objects {
                                
                                let createdBy = object.objectForKey("CreatedBy") as! PFUser
                                let userImage = createdBy["photo"] as! PFFile
                                let description = object.objectForKey("Description") as! String
                                let date = object.createdAt
                                
                                let commentInfo:Comment = Comment(theDescription: description, theCreatorImage: userImage.url!, theCreatorName: createdBy.username!, theTime: date!)
                                
                                comment.append(commentInfo)
                            }
                            
                        }
                        
                        contentQuery?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                            
                            if let objects = objects {
                                
                                for object in objects {
                                   
                                    if let media:PFFile = createdBy["Media"] as? PFFile {
                                        
                                        let title = object.objectForKey("Title") as! String
                                        
                                        let contentInfo:Content = Content(theMedia: media.url!, theTitle: title)
                                        
                                        liveContent.append(contentInfo)
                                    }
                                }
                                
                            }
                            
                        })
                
                    })
                    
                    print("the favEvent is firing \(post)")
                    
                    let theEvent = Event(theID: theID!, theName: profileName,theUserName:userName!, thePost: post, TheProfilePicture: profileImage.url!,theComments:comment,theContent:liveContent)
                    
                    wall.append(theEvent)
                    
                }
                
                SwiftEventBus.post("FavEvent", sender: wall)
            }
            
            
        })

    }

}