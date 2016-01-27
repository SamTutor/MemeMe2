//
//  ViewController.swift
//  MemeMe2
//
//  Created by Mac on 1/25/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import UIKit

class MemeMeEditorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    
    var meme: Meme!
    
    
    // Function to reset the Meme
    func reset() {
        initialTextField(topText, defaultText:"TOP" );
        initialTextField(bottomText, defaultText:"BOTTOM");
        imagePickerView.image = nil
        //cancelButton.enabled = false
        shareButton.enabled = false
    }
    
    
    // Function to view WILL LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }
    
    // Function to view WILL APPEAR
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
        subscribeToKeyboardwillhideNotifications()
        if (imagePickerView.image != nil) {
            cancelButton.enabled = true
            shareButton.enabled = true
        }
    }
    
    
    // Function to view WILL DISAPPEAR
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        unsubscribeFromKeyboardwillhideNotifications()
    }
    
    
    
    /// TOP: NAVIGATION BAR
    /// ----------------------
    
    
    // Function to Cancel the Meme
    @IBAction func memeCancel(sender: AnyObject) {
        cancelButton.title = "Back"
        if (imagePickerView.image != nil)
        {
            reset()
        }
        else
        {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    // Function to GENERATE the MemedImage
    func generateMemedImage() -> UIImage {
        
        navBar.hidden=true
        toolBar.hidden=true
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        toolBar.hidden=false
        navBar.hidden=false
        return memedImage
    }
    
    
    // Function to SAVE the Meme
    func saveMeme() {
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePickerView.image, memeImage: generateMemedImage())
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    
    // Function to Share the Meme
    @IBAction func memeShare(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = {
            activity, completed, returned, error in
            if completed {
                self.saveMeme()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(activityController, animated: true, completion: nil)
    }
    
 
    
    
    /// BODY OF APP
    /// ----------------------
    
    // Function to initialize textFields
    func initialTextField(textField: UITextField, defaultText: String) {
        super.viewDidLoad()
        let memeDefaultTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size:30)!,
            NSStrokeWidthAttributeName :-3.0]
        
        textField.delegate = self
        textField.defaultTextAttributes = memeDefaultTextAttributes
        textField.text = defaultText
        textField.autocapitalizationType = .AllCharacters
        textField.textAlignment = NSTextAlignment.Center
        textField.sizeToFit()
    }
    
    
    // Function to textField Did Begin Editing
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    
    // Function to textField Should Return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // Function to Subscribe from Keyboard WILL SHOW
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:",name: UIKeyboardWillShowNotification, object: nil)
    }
    
    
    // Function to Subscribe from Keyboard WILL HIDE
    func subscribeToKeyboardwillhideNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:",name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    // Function to UnSubscribe from Keyboard WILL SHOW
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    
    // Function to UnSubscribe from Keyboard WILL HIDE
    func unsubscribeFromKeyboardwillhideNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    // Function to Keyboard WILL SHOW
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    
    // Function to Keyboard WILL HIDE
    func keyboardWillHide(notification: NSNotification) {
            view.frame.origin.y = 0
    }
    
    
    // Function to Get Keyboard Height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    
    /// BOTTOM: TOOLBAR
    /// ----------------------
    
    // Function to Use the Photo from Album
    @IBAction func photoAlbum(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    
    // Function to Use the Photo from Camera
    @IBAction func photoCamera(sender: AnyObject) {
        let imageCamera = UIImagePickerController()
        imageCamera.delegate = self
        imageCamera.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imageCamera, animated: true, completion: nil)
    }
    

    // Function of the image Picker
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = .ScaleAspectFit
            imagePickerView.image = image
            dismissViewControllerAnimated(true, completion: nil)
            cancelButton.title = "Cancel"
        }
    }
    
    
    // Function to CANCEL The image Picker
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

