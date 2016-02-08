//
//  JCAssetCell.swift
//  ImagePicker
//
//  Created by Dzmitry Safin on 2/2/16.
//  Copyright © 2016 Dzmitry Safin. All rights reserved.
//

import UIKit

class JCAssetCell: UICollectionViewCell {

    var imageView = UIImageView()
    var checkView = UIImageView(image: UIImage(named: "JCSelectOverlay", inBundle: NSBundle(forClass: JCImagePickerController.self), compatibleWithTraitCollection: nil))

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.frame = self.bounds
        self.contentView.addSubview(imageView)

        checkView.frame.origin = CGPoint(x: self.contentView.bounds.width - checkView.bounds.width, y: self.contentView.bounds.height - checkView.bounds.height)
        self.contentView.addSubview(checkView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override var selected: Bool {
        didSet {
            checkView.hidden = !super.selected
        }
    }
}
