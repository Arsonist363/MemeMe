//
//  detailViewController.swift
//  MemeMe
//
//  Created by Cesar Colorado on 5/3/15.
//  Copyright (c) 2015 Cesar Colorado. All rights reserved.
//

import Foundation

import UIKit

class detailViewController: UIViewController {
    
    
    @IBOutlet weak var memedImage: UIImageView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.memedImage.image = meme.memeImage
    }
    
    
}