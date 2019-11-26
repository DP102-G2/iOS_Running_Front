//
//  ServerTVC.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/26.
//  Copyright © 2019 G2. All rights reserved.
//

import UIKit

class ServerTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerMessageTVC") as! ServerMessageReceiverTVCell
        cell.lbName.text = "Name"
        cell.tvMessage.text = "NameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameNameName"
        cell.lbMessageTime.text = "NameNameNameNameNameNameNameName"
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
