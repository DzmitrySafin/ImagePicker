//
//  JCAssetViewController.swift
//  ImagePicker
//
//  Created by Dzmitry Safin on 2/2/16.
//  Copyright © 2016 Dzmitry Safin. All rights reserved.
//

import UIKit
import Photos

class JCAssetViewController: UICollectionViewController {

    private let assetCellIdentifier = "AssetCell"
    var album: JCAlbum!
    var assets: [JCAsset] = []
    var selectedAssets: [JCAsset] = []

    convenience init() {
        let layout = UICollectionViewFlowLayout()

        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.itemSize = CGSize(width: 80, height: 80)

        self.init(collectionViewLayout: layout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(JCAssetCell.self, forCellWithReuseIdentifier: assetCellIdentifier)

        // Do any additional setup after loading the view.
        self.title = album.title
        self.collectionView!.backgroundColor = UIColor.whiteColor()
        self.collectionView!.allowsMultipleSelection = true

        loadAssets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(assetCellIdentifier, forIndexPath: indexPath) as! JCAssetCell
        let asset = assets[indexPath.row]

        // Configure the cell
        cell.imageView.image = asset.image

        if selectedAssets.contains(asset) {
            cell.selected = true
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.None)
        } else {
            cell.selected = false
            collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        }

        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let asset = assets[indexPath.row]
        selectedAssets.append(assets[indexPath.row])
        PHImageManager.defaultManager().requestImageForAsset(asset.asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.Default, options: nil, resultHandler: { (image, info) in
            asset.image = image
        })
        NSNotificationCenter.defaultCenter().postNotificationName("JCAssetSelected", object: assets[indexPath.row])
    }

    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if let index = selectedAssets.indexOf(assets[indexPath.row]) {
            selectedAssets.removeAtIndex(index)
        }
        NSNotificationCenter.defaultCenter().postNotificationName("JCAssetUnselected", object: assets[indexPath.row])
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

    // MARK: Load data

    func loadAssets() {
        let manager: PHImageManager = PHImageManager.defaultManager()
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.Image.rawValue)

        let collection: PHFetchResult = PHAsset.fetchAssetsInAssetCollection(album.collection, options: fetchOptions)
        collection.enumerateObjectsUsingBlock({ (object, index, stop) in
            let indexPath = NSIndexPath(forRow: self.assets.count, inSection: 0)

            let photo = JCAsset()
            photo.asset = object as! PHAsset
            self.assets.append(photo)

            manager.requestImageForAsset(photo.asset, targetSize: CGSize(width: 80.0, height: 80.0), contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { (image, info) in
                photo.image = image
                self.collectionView?.reloadItemsAtIndexPaths([indexPath])
            })
        })
    }
}
