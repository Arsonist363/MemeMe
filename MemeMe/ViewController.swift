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
    
    // Outlets
    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    // Custome Text Attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.whiteColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //check if camera is availible
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //change the tex fiels properties
        
        topTextField.textAlignment = .Center
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.delegate = self
        bottomTextField.textAlignment = .Center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.delegate = self
        
        
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
        
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
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraImagePicker(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        // Allow image to be cropped
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.cameraCaptureMode = .Photo
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func activity(sender: AnyObject) {
        let memedImage = self.generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            self.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.presentViewController(activityController, animated:true, completion:nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        //change view only on bottom textfield
        if self.bottomTextField.isFirstResponder() == true {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {

        self.returnViewToInitialFrame()
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Erase default text.
        if topTextField.text == "TOP"{
        textField.text = ""
        }
        if bottomTextField.text == "BOTTOM"{
            textField.text = ""
        }
    }
    
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
        var meme = AppDelegate.Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, Image: self.ImagePickerView.image!, memeImage: self.generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        println(appDelegate.memes)
    }
    
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        self.topToolbar.hidden = true
        self.bottomToolbar.hidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        self.topToolbar.hidden = false
        self.bottomToolbar.hidden = false

        return memedImage
    }
    struct Meme {
        var topText: String?
        var bottomText: String?
        var Image = UIImage()
        var memeImage = UIImage()
    }
    
}

