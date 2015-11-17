//
//  FavPartiesViewController.swift
//  Pondu
//
//  Created by Jonathan Green on 11/10/15.
//  Copyright © 2015 Jonathan Green. All rights reserved.
//

import UIKit
import SwiftEventBus
import Kingfisher
import QuartzCore
import Spring

class FavPartiesViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    var array:[Event] = []
    let favParty = partyFavorites()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UltravisualLayout!
    
    override func viewWillAppear(animated: Bool) {
        
        getArrayCount()
        favParty.getFavorite()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return array.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:FavPartyCell = collectionView.dequeueReusableCellWithReuseIdentifier("FavPartyCell", forIndexPath: indexPath) as! FavPartyCell
        
        cell.post.text = array[indexPath.row].post
        cell.PostName.text = array[indexPath.row].name
        cell.likes.text = "Likes:\(array[indexPath.row].likes)"
        
        let numComments = array[indexPath.row].comments
        
        cell.comments.text = "Comments:\(numComments.count)"
        cell.profileImage.kf_setImageWithURL(NSURL(string:array[indexPath.row].profilePicture)!, placeholderImage: UIImage(named: "placeholder"))
        cell.bgImage.kf_setImageWithURL(NSURL(string:array[indexPath.row].profilePicture)!, placeholderImage: UIImage(named: "placeholder"))
        
        
        if array[indexPath.row].live == true {
            
            cell.live.text = "Live"
            cell.live.repeatCount = Float.infinity
            cell.live.animate()
            
        }else {
            
            
            cell.live.text = "Peak"
            cell.live.textColor = UIColor.whiteColor()
        }
        
        
        print("post in array \(self.array.count)")
        
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let layout = collectionViewLayout as UltravisualLayout
        let offset = layout.dragOffset * CGFloat(indexPath.item)
        if collectionView.contentOffset.y != offset {
            collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        }
        
        if indexPath.item == layout.featuredItemIndex {
            
            print("featured")
        }else{
            
            print("not featured")
        }
    }
    
    
    
    func getArrayCount(){
        
        SwiftEventBus.onMainThread(self, name: "updateFavoritePartyCell") { notification in
            
            print("passing data\(notification.object)")
            
            self.array = notification.object as! [Event]
            
            print(self.array.count)
            
            self.collectionView.reloadData()
            
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
