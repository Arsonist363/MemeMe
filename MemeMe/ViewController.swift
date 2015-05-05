//
//  ViewController.swift
//  MemeMe
//
//  Created by Cesar Colorado on 4/18/15.
//  Copyright (c) 2015 Cesar Colorado. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate{
    
    var memes: [Meme]!
    
    //temp test case
    //var Temp = Meme(topText: "This is a test Case", bottomText: "Not ment for Viewing", image: UIImage(named: "LaunchImage")!, memeImage: UIImage(named: "LaunchImage")!)
    
    
    // Outlets
    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // Custome Text Attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.whiteColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3
    ]
    
    var showTableView = false
    var allowEdittext = false
    var allowShare = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //check meme data
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        //addes test case to memes to check presentation of tableview
        //appDelegate.memes.append(Temp)
        
        //Checks for memes if found returns the tableview
        if appDelegate.memes.count > 0 {
            showTableView = true
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //check if camera is availible
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        shareButton.enabled = allowShare
        //change the text field properties
        //top
        topTextField.textAlignment = .Center
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.delegate = self
        
        //bottom
        bottomTextField.textAlignment = .Center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.delegate = self
        
        
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
        
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        //returns table view
        if showTableView {
            self.showAllMeme()
            showTableView = false
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // Image picker Controller
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.ImagePickerView.image = image
        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func photoLibaryImagePicker(sender: AnyObject) {

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        // Allow image to be cropped
        imagePicker.allowsEditing = true
        
        // Allows for textfield edit and sharebutton
        allowEdittext = true
        allowShare = true
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraImagePicker(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // Allow image to be cropped
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.cameraCaptureMode = .Photo
        
        // Allows for textfield edit and sharebutton
        allowEdittext = true
        allowShare = true
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func activity(sender: AnyObject) {
        // allows for sharing of images
        let memedImage = self.generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            self.save()
            self.showAllMeme()
        }
        
        self.presentViewController(activityController, animated:true, completion:nil)
    }
    
    @IBAction func cancell(sender: AnyObject) {
        //makes the tabview
        showAllMeme()
    }
    func keyboardWillShow(notification: NSNotification) {
        //change view only on bottom textfield
        if self.bottomTextField.isFirstResponder() == true {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        // returnes view to normal
        self.returnViewToInitialFrame()
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // prevents text from being edited
        return allowEdittext;
    }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Erase default text.
        if topTextField.text == " TOP "{
        textField.text = ""
        }
        
        if bottomTextField.text == " BOTTOM "{
            textField.text = ""
        }
    }
    
    //dismiss keyboard after return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    //returns view after keyboard dismisal
    func returnViewToInitialFrame()
    {
        var initialViewRect: CGRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)
        
        if (!CGRectEqualToRect(initialViewRect, self.view.frame))
        {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame = initialViewRect
            });
        }
    }
    
    
    func save() {
        //Save  the meme
        var meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: self.ImagePickerView.image!, memeImage: self.generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
       
    }
    
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        self.navBar.hidden = true
        self.bottomToolbar.hidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        self.navBar.hidden = false
        self.bottomToolbar.hidden = false

        return memedImage
    }
    
    func showAllMeme(){
        //Present tabview
        var controller: UITabBarController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarview") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
   
    
}

