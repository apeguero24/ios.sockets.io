//
//  RoomTableViewCell.swift
//  sockets.io
//
//  Created by Muhand Jumah on 3/1/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {

    @IBOutlet weak var RoomName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
