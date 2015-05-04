//
//  MemeMeTableViewController.swift
//  MemeMe
//
//  Created by Cesar Colorado on 5/2/15.
//  Copyright (c) 2015 Cesar Colorado. All rights reserved.
//

import UIKit

class MemeMeTableViewController: UITableViewController, UITableViewDataSource  {
    
    var memes: [Meme]!
    
   
    @IBAction func addMeme(sender: AnyObject) {
        // dismiss the current view and presents the editor
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        self.tableView.reloadData()
    }
    

    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return self.memes.count
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        
    {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "myCell")
        //gets  meme
        var currentMeme = self.memes[indexPath.row]
        
        //set the text and image
        cell.textLabel?.text = currentMeme.topText + "...." + currentMeme.bottomText
        cell.imageView?.image = currentMeme.memeImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // When cell is pressed the detailView is presented        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("detailView")! as! detailViewController
        
        // gets current meme
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}