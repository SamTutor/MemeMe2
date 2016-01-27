//
//  MemeMeCollectionController.swift
//  MemeMe2
//
//  Created by Mac on 1/26/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import UIKit

class MemeMeCollectionController: UICollectionViewController {
    
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
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
        collectionView!.reloadData()
    }
    
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2*space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        noMemesLabel = UILabel(frame: CGRectMake(0,0,collectionView!.bounds.size.width,collectionView!.bounds.size.height))
        noMemesLabel.text = "No memes available. \nAdd one with the + button."
        noMemesLabel.textAlignment = NSTextAlignment.Center
        noMemesLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        noMemesLabel.numberOfLines = 2
        noMemesLabel.sizeToFit()
        noMemesLabel.font = UIFont(name: "HelveticaNeue", size: 25)!
        noMemesLabel.textColor = UIColor.whiteColor()
        collectionView?.backgroundView = noMemesLabel
    }
    
    
    // Function to count the num of memes
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (memes.count > 0) {
            noMemesLabel.hidden = true
        }
        else {
            noMemesLabel.hidden = false
        }
        return memes.count
    }
    
    
    // Function to populate the Table View Cell
    override func collectionView(tableView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView!.dequeueReusableCellWithReuseIdentifier("savedMemeCollectionCell", forIndexPath: indexPath) as! MemeMeCollectionViewCell
                
        let meme = memes[indexPath.row]
        cell.memImage.image = meme.memeImage
        
        //cell.topbotLabel.text = meme.topText! + "..." + meme.bottomText!
        //cell.topbotLabel.sizeToFit()
        //cell.topbotLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        //cell.topbotLabel.numberOfLines = 2
        //cell.topbotLabel.font = UIFont(name: "HelveticaNeue", size: 15)!
        
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("MemeMeDetailView") as! MemeMeDetailView
        detailViewController.meme = memes[indexPath.row]
        presentViewController(detailViewController, animated: true, completion: nil)
    }
    
}
