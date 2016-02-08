//
//  JCAlbumCell.swift
//  ImagePicker
//
//  Created by Dzmitry Safin on 2/2/16.
//  Copyright © 2016 Dzmitry Safin. All rights reserved.
//

import UIKit

class JCAlbumCell: UITableViewCell {

    static let cellSize: CGFloat = 92.0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)

        self.imageView!.contentMode = UIViewContentMode.ScaleToFill
        self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.imageView!.frame = CGRectMake(8, 8, JCAlbumCell.cellSize - 8 - 8, JCAlbumCell.cellSize - 8 - 8)
        self.textLabel!.frame = CGRectMake(JCAlbumCell.cellSize + 8, self.textLabel!.frame.origin.y, self.textLabel!.frame.width, self.textLabel!.frame.height)
        self.detailTextLabel!.frame = CGRectMake(JCAlbumCell.cellSize + 8, self.detailTextLabel!.frame.origin.y, self.detailTextLabel!.frame.width, self.detailTextLabel!.frame.height)
    }
}
