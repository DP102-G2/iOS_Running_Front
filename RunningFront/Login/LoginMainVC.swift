//
//  LoginMainVC.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/20.
//  Copyright © 2019 G2. All rights reserved.
//

import FacebookLogin
import UIKit

class LoginMainVC: UIViewController {
    
    
    @IBOutlet weak var tfUserAccount: UITextField!
    @IBOutlet weak var tfUserPassword: UITextField!
    let url = URL(string: "\(common_url)SettingServlet")
    var user : User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btFBLogin(_ sender: Any) {
        
        let manager = LoginManager()
        manager.logIn(permissions: [.publicProfile], viewController: self) { (result) in
            if case LoginResult.success(granted: _, declined: _, token: _) = result {
                print("login ok")
                Profile.loadCurrentProfile { (profile, error) in
                    if let profile = profile{
                        
                        var requestParam = [String:String]()
                        requestParam["action"] = "googleSignIn"
                        requestParam["user_id"] = profile.userID
                        requestParam["user_name"] = profile.name
                        requestParam["user_email"] = ""
                        let dateStr = dateFormat(date: Date())
                        requestParam["user_regtime"] = dateStr
                        executeTask(self.url!, requestParam) { (data, response, error) in
                            if data != nil && error == nil{
                                
                                let dic = dataToDictionary(data: data!)
                                let user_no = dic!["user_no"]
                                
                                DispatchQueue.main.sync {
                                    UserDefaults.standard.set(user_no, forKey: "user_no")
                                    naviToRun(VC: self)
                                }
                            }
                        }
                    }
                }
                manager.logOut()
            } else {
                showSimpleAlert(message: "登入失敗，請重新嘗試", viewController: self)
            }
        }
        
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
