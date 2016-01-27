//
//  MemeMeDetailView.swift
//  MemeMe2
//
//  Created by Mac on 1/25/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import UIKit

class MemeMeDetailView: UIViewController {
   
    @IBOutlet weak var memImage: UIImageView!
    
    /// Meme variable
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memImage.image = meme.memeImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func memeBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
