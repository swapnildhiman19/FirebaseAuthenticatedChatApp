//
//  MessageCellTableViewCell.swift
//  Flash Chat iOS13
//
//  Created by Swapnil Dhiman on 04/07/25.
//  Copyright © 2025 Angela Yu. All rights reserved.
//

import UIKit

class MessageCellTableViewCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code from whatever we put it in .xib file or storyboard
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
        label.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
