//
//  CollectionViewController.swift
//  ImagePicker
//
//  Created by Dzmitry Safin on 1/30/16.
//  Copyright © 2016 Dzmitry Safin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoCell"

class CollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var singlePicker = UIImagePickerController()

    var selectedPhotos: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        singlePicker.allowsEditing = false
        singlePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Buttons - UIImagePickerController

    @IBAction func btnSingleCameraClick(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            singlePicker.sourceType = UIImagePickerControllerSourceType.Camera
            singlePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Photo
            singlePicker.modalPresentationStyle = UIModalPresentationStyle.FullScreen
            self.presentViewController(singlePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Image Picker", message: "Camera is not available!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    @IBAction func btnSingleLibraryClick(sender: UIBarButtonItem) {
        singlePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.presentViewController(singlePicker, animated: true, completion: nil)
        } else {
            singlePicker.modalPresentationStyle = UIModalPresentationStyle.Popover
            singlePicker.popoverPresentationController!.permittedArrowDirections = UIPopoverArrowDirection.Any
            singlePicker.popoverPresentationController!.sourceView = self.view
            singlePicker.popoverPresentationController!.sourceRect = CGRectZero
            singlePicker.popoverPresentationController!.barButtonItem = sender
            self.presentViewController(singlePicker, animated: true, completion: nil)
        }
    }

    // MARK: Buttons - JCImagePickerController

    @IBAction func btnMultiCameraClick(sender: UIBarButtonItem) {
    }

    @IBAction func btnMultiLibraryClick(sender: UIBarButtonItem) {
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
        return selectedPhotos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell

        // Configure the cell
        cell.imageView.image = selectedPhotos[indexPath.row]

        return cell
    }

    // MARK: UICollectionViewDelegate

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

    // MARK: UIImagePickerControllerDelegate

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        selectedPhotos.append(info[UIImagePickerControllerOriginalImage] as! UIImage)

        self.collectionView!.reloadData()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
