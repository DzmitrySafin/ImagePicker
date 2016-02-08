//
//  JCImagePickerController.swift
//  ImagePicker
//
//  Created by Dzmitry Safin on 2/2/16.
//  Copyright © 2016 Dzmitry Safin. All rights reserved.
//

import UIKit

class JCImagePickerController: UINavigationController {

    var selectedAssets: [JCAsset] = []

    weak var pickerDelegate: JCImagePickerControllerDelegate?
    override var delegate: UINavigationControllerDelegate? {
        didSet {
            pickerDelegate = delegate as? JCImagePickerControllerDelegate
        }
    }

    convenience init() {
        let tableController = JCAlbumViewController()
        self.init(rootViewController: tableController)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageSelected:", name: "JCAssetSelected", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageUnselected:", name: "JCAssetUnselected", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func pushViewController(viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        if self.viewControllers.count == 1 {
            self.topViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "btnCancelClick")
        } else {
            self.topViewController!.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "btnSelectClick")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: NSNotificationCenter

    func imageSelected(notification: NSNotification) {
        if let asset = notification.object as? JCAsset {
            selectedAssets.append(asset)
        }
    }

    func imageUnselected(notification: NSNotification) {
        if let asset = notification.object as? JCAsset {
            if let index = selectedAssets.indexOf(asset) {
                selectedAssets.removeAtIndex(index)
            }
        }
    }

    // MARK: Navigation Bar buttons

    func btnCancelClick() {
        if let delegate = self.pickerDelegate {
            delegate.multiPickerControllerDidCancel?(self)
        }
    }

    func btnSelectClick() {
        if let delegate = self.pickerDelegate {
            delegate.multiPickerController?(self, didFinishPickingAssets: self.selectedAssets)
        }
    }
}
