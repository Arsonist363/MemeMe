//
//  ViewController.swift
//  MemeMe
//
//  Created by Cesar Colorado on 4/18/15.
//  Copyright (c) 2015 Cesar Colorado. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // Custome Text Attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : 6
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
        topTextField.enabled = true
        topTextField.textAlignment = .Center
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.enabled = true
        bottomTextField.textAlignment = .Center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
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
}

