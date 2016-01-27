//
//  MemeMeTableController.swift
//  MemeMe2
//
//  Created by Mac on 1/25/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import UIKit
    
    class MemeMeTableController: UITableViewController {
        
        // Label to notify that there is no memes on the list
        var noMemesLabel: UILabel!
        
        
        // Meme array
        var memes : [Meme]!
        var selectedIndex: Int?
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
      
        // viewWillAppear
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            tabBarController?.tabBar.hidden = false
            memes = applicationDelegate.memes
            tableView.reloadData()
        }
        
        
        // viewDidLoad
        override func viewDidLoad() {
            super.viewDidLoad()
        
            noMemesLabel = UILabel(frame: CGRectMake(0,0,tableView.bounds.size.width,tableView.bounds.size.height))
            noMemesLabel.text = "No memes available. \nAdd one with the + button."
            noMemesLabel.textAlignment = NSTextAlignment.Center
            noMemesLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            noMemesLabel.numberOfLines = 2
            noMemesLabel.sizeToFit()
            noMemesLabel.font = UIFont(name: "HelveticaNeue", size: 25)!
            
            tableView.backgroundView = noMemesLabel
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        
        
        // Function to count the num of memes
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if (memes.count > 0) {
                noMemesLabel.hidden = true
            }
            else {
                noMemesLabel.hidden = false
            }
            return memes.count
        }
        
        
        // Function to populate the Table View Cell
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("savedTableCell") as! MemeMeTableViewCell
            let meme = memes[indexPath.row]
            cell.memImage.image = meme.memeImage
            cell.topbotLabel.text = meme.topText! + "..." + meme.bottomText!
            cell.topbotLabel.sizeToFit()
            cell.topbotLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            cell.topbotLabel.numberOfLines = 2
            cell.topbotLabel.font = UIFont(name: "HelveticaNeue", size: 15)!
            
            return cell
        }
        
        
        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("MemeMeDetailView") as! MemeMeDetailView
            detailViewController.meme = memes[indexPath.row]
            presentViewController(detailViewController, animated: true, completion: nil)
        }
   
}