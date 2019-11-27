//
//  SettingMainTVC.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/25.
//  Copyright © 2019 G2. All rights reserved.
//

import UIKit

class SettingMainTVC: SettingTVC {
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    var image : UIImage?
    var user_no = 0
    let url = URL(string: "\(common_url)SettingServlet")
    
    var user_id = ""
    var user_pw = ""
    var user_name = ""
    var user_email = ""
    var user_private = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user_no = getUserNo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserInfo()
        getImage()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        switch index {
        case 1:
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SettingEditTVC") as! UITableViewController
            navigationController?.pushViewController(VC, animated: true)
        case 3:
            if logout(VC: self) {
                naviToLogin(VC: self)
            }
        default:
            break
        }
        
    }
    
}

extension SettingMainTVC{
    
    func getImage() {
        
        var requestParam = [String:String]()
        requestParam["action"] = "getiOSImage"
        requestParam["user_no"] = String(user_no)
        executeTask(url!, requestParam) { (data, response, error) in
            DispatchQueue.main.async {
                print("getImage Success")
                self.imageView.image = UIImage(data: data!)
                self.saveUserInfoInUserDefault()
            }
            
        }
    }
    
    func getUserInfo() {
        
        var requestParam = [String:String]()
        requestParam["action"] = "showUserInfo"
        requestParam["user_no"] = String(user_no)
        executeTask(url!, requestParam) { (data, response, error) in
            let jsonObject = dataToDictionary(data: data!)
            self.user_id = jsonObject!["user_id"] as! String
            self.user_pw = jsonObject!["user_pw"] as! String
            self.user_name = jsonObject!["user_name"] as! String
            self.user_email = jsonObject!["user_email"] as! String
            self.user_private = jsonObject!["user_private"] as! Int
            print("getUserInfo Success")

        }
        
    }
    
    func saveUserInfoInUserDefault() {
        
        let userDefault = UserDefaults.standard
        
        userDefault.set(user_id, forKey: "user_id")
        userDefault.set(user_pw, forKey: "user_pw")
        userDefault.set(user_name, forKey: "user_name")
        userDefault.set(user_email, forKey: "user_email")
        userDefault.set(user_private, forKey: "user_private")
        
        if self.imageView.image != nil {
        
        DispatchQueue.main.async {
            if let imageData = self.imageView.image!.jpegData(compressionQuality: 1.0) {
                userDefault.set(imageData, forKey: "user_image")
                // value,Key
            }
        }
        }

        print("SaveInfo Success")
    }
}
