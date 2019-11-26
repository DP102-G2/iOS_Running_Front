//
//  SeverMessageTVC.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/26.
//  Copyright © 2019 G2. All rights reserved.
//

import UIKit

class ServerMessageReceiverTVCell: UITableViewCell {

    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet weak var lbMessageTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tvMessage.textContainerInset = UIEdgeInsets(top: 5, left: 15, bottom: 10, right: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
