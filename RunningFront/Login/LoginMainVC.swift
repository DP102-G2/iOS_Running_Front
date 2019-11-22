//
//  LoginMainVC.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/20.
//  Copyright © 2019 G2. All rights reserved.
//

import UIKit

class LoginMainVC: UIViewController {
    
    
    @IBOutlet weak var tfUserAccount: UITextField!
    @IBOutlet weak var tfUserPassword: UITextField!
    let url = URL(string: "\(common_url)SettingServlet")
    var login : User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btLogin(_ sender: Any) {
        
        
        let account = tfUserAccount.text
        let password = tfUserPassword.text
        var user = User(account!, password!)
        let data = try! String(data: JSONEncoder().encode(user), encoding: .utf8)
        
        var requestParam = [String:String]() // jsonobject -> dic
        requestParam["action"] = "signin"
        requestParam["user"] = data!
        
        executeTask(url!, requestParam) { (data, response, error) in
            if error == nil && data != nil{
                if let mLogin = try? JSONDecoder().decode(User.self, from: data!){
                    user = mLogin
                    DispatchQueue.main.sync {
                        UserDefaults.standard.set(try! JSONEncoder().encode(user), forKey: "userLogin")
                        UserDefaults.standard.set(user.no, forKey: "user_no")
                        naviToRun(VC: self)
                    }
                }else{
                    DispatchQueue.main.sync {
                        showSimpleAlert(message: user.id!, viewController: self)
                    }
                    
                }
                
            }
        }
        
    }
    
    
}
