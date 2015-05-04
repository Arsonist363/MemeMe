//
//  MemeMeData.swift
//  MemeMe
//
//  Created by Cesar Colorado on 4/30/15.
//  Copyright (c) 2015 Cesar Colorado. All rights reserved.
//


import Foundation
import UIKit


class Meme {

    var topText = ""
    var bottomText = ""
    var image = UIImage()
    var memeImage = UIImage()
    
    //initiates meme types
    init(topText:String, bottomText: String, image:UIImage, memeImage:UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memeImage = memeImage
    }
}