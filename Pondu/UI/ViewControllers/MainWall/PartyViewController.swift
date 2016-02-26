//
//  PartyViewController.swift
//  Pondu
//
//  Created by Jonathan Green on 11/6/15.
//  Copyright © 2015 Jonathan Green. All rights reserved.
//

import UIKit
import SwiftEventBus
import Parse
import Kingfisher
import QuartzCore
import Spring
import BubbleTransition

class PartyViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UIViewControllerTransitioningDelegate{

    let Parties = PartiesMainWall()
    let eventID:[String] = []
    var count:Int = 0
    var array:[Event] = []
    var numOfCells:[String] = []
    var numOfPost:[String] = []
    let transition = BubbleTransition()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UltravisualLayout!
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        Parties.partiesPost { (result) -> Void in
            
            self.array = result
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        transition.duration = 0.4
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
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:PartyCell = collectionView.dequeueReusableCellWithReuseIdentifier("PartyCell", forIndexPath: indexPath) as! PartyCell
        
       
        
        cell.post.text = array[indexPath.item].post
        cell.PostName.text = array[indexPath.item].name
        cell.likes.text = "Likes:\(array[indexPath.item].likes)"
        
        
        cell.profileImage.kf_setImageWithURL(NSURL(string:array[indexPath.row].profilePicture)!, placeholderImage: UIImage(named: "placeholder"))

        if array[indexPath.item].live == true {
            
            //cell.pulseEffect.hidden = false
            
             cell.live.setTitle("Live", forState: UIControlState.Normal)
        }else {
            
            
            cell.live.setTitle("Peak", forState: UIControlState.Normal)
            cell.live.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        }
        
        cell.layoutSubviews()
        
        print("post in array \(self.array.count)")
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //let addFavorite = Favorite()
        //addFavorite.userFavorite(array[indexPath.row].objectID)
        //addFavorite.userPartyFavorite(array[indexPath.row].objectID)
        
        let layout = collectionViewLayout as UltravisualLayout
        let offset = layout.dragOffset * CGFloat(indexPath.item)
        if collectionView.contentOffset.y != offset {
            collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        }
        
        if indexPath.item == layout.featuredItemIndex {
            
            print("featured")
            
            self.performSegueWithIdentifier("Live", sender: indexPath);
            
        }else{
            
            print("not featured")
        }
    }
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Live" {
            
            let liveController = segue.destinationViewController as! LiveViewController
            
            liveController.transitioningDelegate = self
            liveController.modalPresentationStyle = .Custom
            
            let item = (sender as! NSIndexPath).item
            liveController.eventId = array[item].objectID
           
            print(item)
            
        }
    }

}
