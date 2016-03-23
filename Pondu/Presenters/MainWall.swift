//
//  MainWall.swift
//  Pondu
//
//  Created by Jonathan Green on 10/25/15.
//  Copyright © 2015 Jonathan Green. All rights reserved.
//

import UIKit
import SwiftEventBus

class PresentMainWall {
    

    func eventPost(completion:(result:[Wall]) -> Void){
        
        SwiftEventBus.onMainThread(self, name: "MainWallEvent") { result in
            
            print("MainWall Fired")
            
            if let post = result.object as? [Wall] {
                
                print("event post \(post)")
                //SwiftEventBus.post("updateCell", sender: post)
                SwiftEventBus.unregister(self, name: "MainWallEvent")
                
                completion(result: post)
            }
           
        }

    }
    
    func favPost(completion:(result:[Wall]) -> Void){
        
        SwiftEventBus.onMainThread(self, name: "FavEvent") { result in
            
            if let data:[Wall] = result.object as? [Wall] {
                
                SwiftEventBus.unregister(self, name: "FavEvent")
                completion(result: data)
            }
            
        }
        
    }
}

