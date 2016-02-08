//
//  JCImagePickerControllerDelegate.swift
//  ImagePicker
//
//  Created by Dzmitry Safin on 2/2/16.
//  Copyright © 2016 Dzmitry Safin. All rights reserved.
//

import UIKit

@objc protocol JCImagePickerControllerDelegate: NSObjectProtocol {

    optional func multiPickerController(picker: JCImagePickerController, didFinishPickingAssets assets: [JCAsset])
    optional func multiPickerControllerDidCancel(picker: JCImagePickerController)
}
