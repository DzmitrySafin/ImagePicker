//
//  JCAlbumViewController.swift
//  ImagePicker
//
//  Created by Dzmitry Safin on 2/2/16.
//  Copyright © 2016 Dzmitry Safin. All rights reserved.
//

import UIKit
import Photos

class JCAlbumViewController: UITableViewController {

    private let albumCellIdentifier = "AlbumCell"
    var albums: [JCAlbum] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        self.title = "Photos"
        self.tableView.registerClass(JCAlbumCell.self, forCellReuseIdentifier: albumCellIdentifier)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.rowHeight = JCAlbumCell.cellSize

        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(albumCellIdentifier, forIndexPath: indexPath) as! JCAlbumCell
        let album = albums[indexPath.row]

        // Configure the cell...
        cell.textLabel!.text = album.title
        cell.detailTextLabel!.text = String(album.number)
        cell.imageView!.image = album.thumbnail

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let album = albums[indexPath.row]

        let assetViewController = JCAssetViewController()
        assetViewController.album = album

        self.navigationController?.pushViewController(assetViewController, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Load data

    func loadData() {
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if status == PHAuthorizationStatus.Authorized {
            self.loadAlbums()
        } else if status == PHAuthorizationStatus.NotDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.Authorized {
                    dispatch_async(dispatch_get_main_queue(), { self.loadAlbums() })
                } else {
                    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        } else {
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func loadAlbums() {
        let cameraRoll: PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.SmartAlbum, subtype: PHAssetCollectionSubtype.SmartAlbumUserLibrary, options: nil)
        loadAlbumsFromCollection(cameraRoll)

        let allAlbums: PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.Album, subtype: PHAssetCollectionSubtype.Any, options: nil)
        loadAlbumsFromCollection(allAlbums)

        tableView.reloadData()
    }

    func loadAlbumsFromCollection(collection: PHFetchResult) {
        let manager: PHImageManager = PHImageManager.defaultManager()
        let options: PHFetchOptions = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.Image.rawValue)

        collection.enumerateObjectsUsingBlock({ (object, index, stop) in
            let assetCollection: PHAssetCollection = object as! PHAssetCollection
            let assets: PHFetchResult = PHAsset.fetchAssetsInAssetCollection(assetCollection, options: options)
            let indexPath = NSIndexPath(forRow: self.albums.count, inSection: 0)

            let album = JCAlbum()
            album.title = assetCollection.localizedTitle
            album.number = assets.count
            album.collection = assetCollection
            self.albums.append(album)

            if let asset = assets.firstObject as? PHAsset {
                manager.requestImageForAsset(asset, targetSize: CGSize(width: 80.0, height: 80.0), contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { (image, info) in
                    album.thumbnail = image
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                })
            }
        })
    }
}
