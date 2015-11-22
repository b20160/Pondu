//
//  makeEvent.swift
//  Pondu
//
//  Created by Jonathan Green on 11/3/15.
//  Copyright © 2015 Jonathan Green. All rights reserved.
//

import UIKit
import Parse

class makeEvent {
    
    var name:String = ""
    var post:String = ""
    var profilePicture:PFFile!
    var likes:Int = 0
    var location:String = ""
    var live:Bool = false
    var date:String!
    var startTime:String!
    var endTime:String!
    
    init(theName:String,thePost:String,TheProfilePicture:PFFile,theLocation:String,theLive:Bool,thelikes:Int,theDate:String,theStartTime:String,theEndTime:String){
        
        name = theName
        post = thePost
        profilePicture = TheProfilePicture
        location = theLocation
        live = theLive
        likes = thelikes
        date = theDate
        startTime = theStartTime
        endTime = theEndTime
    }
    
}
