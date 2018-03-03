//
//  TextMessageTableViewCell.swift
//  sockets.io
//
//  Created by Muhand Jumah on 2/28/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit

class TextMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var TextMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
