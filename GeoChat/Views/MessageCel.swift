//
//  MessageCel.swift
//  Flash Chat iOS13
//
//  Created by Frank Solleveld on 11/04/2020.
//

import UIKit

class MessageCel: UITableViewCell {
    
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var messageBody: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    
    // MARK: - TODO: Change chat bubble color for sender
    // MARK: - TODO: Change 'Me' label to right side instead of the left side for consistency.
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
