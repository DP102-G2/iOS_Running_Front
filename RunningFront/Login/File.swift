//
//  SignUpTVC.swift
//  Pods-RunningFront
//
//  Created by FanFan on 2019/11/20.
//

import UIKit
import Foundation

class Test: UITableViewController {
    

    let url = URL(string: "\(common_url)SettingServlet")
    
    @IBOutlet weak var tfID: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfMail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func btSignUp(_ sender: Any) {

        let id = tfID.text
        let name = tfName.text
        let password = tfPassword.text
        let email = tfMail.text

        var requestParam = [String:String]()
        requestParam["action"] = "singup"
        requestParam["user_id"] = id
        requestParam["user_pw"] = password
        requestParam["user_email"] = email
        requestParam["user_name"] = name
        executeTask(url! , requestParam) { (data, response, error) in
            if data != nil && error == nil {
                if let count = try? JSONDecoder().decode(Int.self, from: data!){
                    if count == 1{
                        showSimpleAlert(message: "Success", viewController: self)
                    }
                }
            }
        }


    }
    
}
