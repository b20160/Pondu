//
//  SideViewController.swift
//  Pondu
//
//  Created by Jonathan Green on 5/13/16.
//  Copyright © 2016 Jonathan Green. All rights reserved.
//

import UIKit

enum DrawerSection: Int {
    case ViewSelection
    case DrawerWidth
    case ShadowToggle
    case OpenDrawerGestures
    case CloseDrawerGestures
    case CenterHiddenInteraction
    case StretchDrawer
}

class SideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    let drawerWidths: [CGFloat] = [160, 200, 240, 280, 320]
    
    let accountDetails = ["Edit Pofile","Account Settings","Notifications"]
    let accoutIcons = ["round","cogwheel","sound"]
    let accoutIcon = "key"
    
    let legal = ["Help","Terms of Service","Privacy Policy","Pondu-app.com"]
    let legalIcons = ["people","tool","security","window"]
    let legalIcon = "legal"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: self.view.frame, style: .Grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.autoresizingMask = [ .FlexibleWidth, .FlexibleHeight ]
        
        self.tableView.backgroundColor = UIColor.darkGrayColor()
        self.tableView.separatorStyle = .None
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 161 / 255, green: 164 / 255, blue: 166 / 255, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 55 / 255, green: 70 / 255, blue: 77 / 255, alpha: 1.0)]
        
        //self.view.backgroundColor = UIColor.darkGrayColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // See https://github.com/sascha/DrawerController/issues/12
        self.navigationController?.view.setNeedsLayout()
        
        self.tableView.reloadSections(NSIndexSet(indexesInRange: NSRange(location: 0, length: self.tableView.numberOfSections - 1)), withRowAnimation: .None)
    }
    
     func contentSizeDidChange(size: String) {
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return accountDetails.count
        case 1:
            return legal.count
        default:
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "Cell"
        
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as UITableViewCell?
        
        if cell == nil {
            cell = SideDrawerTableViewCell(style: .Default, reuseIdentifier: CellIdentifier)
            cell.selectionStyle = .Blue
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        switch indexPath.section {
        case 0:
            
            cell.textLabel?.text = accountDetails[indexPath.row]
            cell.imageView?.image = UIImage(named: accoutIcons[indexPath.row])
            
        case 1:
            
            cell.textLabel?.text = legal[indexPath.row]
            
            cell.imageView?.image = UIImage(named: legalIcons[indexPath.row])

            
        default: break
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        tableView.headerViewForSection(section)?.textLabel?.textColor = UIColor.whiteColor()
        
        switch section {
        case DrawerSection.ViewSelection.rawValue:
            return "Account Details"
        case DrawerSection.DrawerWidth.rawValue:
            return "Legal"

        default:
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        
        UIGraphicsBeginImageContext( newSize )
        image.drawInRect(CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage.imageWithRenderingMode(.AlwaysTemplate)
    }

    
    // MARK: - UITableViewDelegate

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
