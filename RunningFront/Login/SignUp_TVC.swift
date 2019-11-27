//
//  SignUpTVC.swift
//  Pods-RunningFront
//
//  Created by FanFan on 2019/11/20.
// 註冊之後放入偏好設定

import UIKit
import Foundation

class SignUp_TVC: UITableViewController {
    

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
        let now = Date()
        let dateStr = dateFormat(date: now)
        print(dateStr)

        var requestParam = [String:String]()
        requestParam["action"] = "SignUp_return"
        requestParam["user_id"] = id
        requestParam["user_pw"] = password
        requestParam["user_email"] = email
        requestParam["user_name"] = name
        requestParam["user_regtime"] = dateStr
        executeTask(url! , requestParam) { (data, response, error) in
            if data != nil && error == nil {
                if let user_no = try? JSONDecoder().decode(Int.self, from: data!){
                    if user_no != 0{
                        UserDefaults.standard.set(user_no, forKey: "user_no")
                        DispatchQueue.main.async {
                            naviToRun(VC: self)
                        }
                    }else {
                        DispatchQueue.main.async {
                            showSimpleAlert(message: "false", viewController: self)
                        }
                    }
                }
            }
        }


    }
    
}
