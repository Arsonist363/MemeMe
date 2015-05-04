//
//  MemeMeCollectionViewController.swift
//  MemeMe
//
//  Created by Cesar Colorado on 5/2/15.
//  Copyright (c) 2015 Cesar Colorado. All rights reserved.
//

import Foundation
import UIKit

class MemeMeCollectionViewController: UICollectionViewController, UICollectionViewDataSource {
    
    var memes: [Meme]!
    
    //set the reuseIdentifier
    let reuseIdentifier = "MyCell"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        self.collectionView?.reloadData()
    }
    
    @IBAction func addMeme(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeMeCollectionViewCell
        
        //sets the memes
        var currentMeme = self.memes[indexPath.row]
        
        // Set the image
        cell.originalImage.image = currentMeme.memeImage
        
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        // When cell is pressed the detailView is presented
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("detailView")! as! detailViewController
        //gets current meme        
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}