//
//  SettingEditTVC.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/25.
//  Copyright © 2019 G2. All rights reserved.
//

import UIKit

class SettingEditTVC: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbID: UILabel!
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPw: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var swPrivate: UISwitch!
    
    var image : UIImage?
    var user_id = ""
    var user_no = getUserNo()
    var user_name = ""
    var user_email = ""
    var user_password = ""
    var user_private = 0
    var userDefaults = UserDefaults.standard
    
    let url = URL(string: "\(common_url)SettingServlet")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
        setView()
    }
    
    @IBAction func swValueChanged(_ sender: UISwitch) {
        
        if sender.isOn {
            user_private = 1
        } else {
            user_private = 0
        }
        
        print("user_private: \(String(user_private))")
        
    }
    
    @IBAction func btDone(_ sender: UIBarButtonItem) {
        
        let AlertCtr = UIAlertController(title: "請確認是否送出修改", message: nil, preferredStyle: .alert)
        
        let actionAlert = UIAlertAction(title: "確認", style: .default) { (action) in
            self.user_email = self.tfEmail.text!
            self.user_password = self.tfPw.text!
            self.user_name = self.tfName.text!
            
            var requestParam = [String:String]()
            requestParam["action"] = "update"
            requestParam["user_no"] = String(self.user_no)
            requestParam["user_pw"] = self.user_password
            requestParam["user_name"] = self.user_name
            requestParam["user_email"] = self.user_email
            requestParam["user_private"] = String(self.user_private)
            requestParam["user_imageBase64"] = self.image?.jpegData(compressionQuality: 1.0)?.base64EncodedString()
            
            executeTask(self.url!, requestParam) { (data, response, error) in
                if let count = String(data: data!, encoding: .utf8),count == "true" {
                    
                    DispatchQueue.main.async {
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                }
                
            }
        }
        let cancelAlert = UIAlertAction(title: "取消", style: .cancel ,handler: nil)
        
        AlertCtr.addAction(actionAlert)
        AlertCtr.addAction(cancelAlert)
        self.present(AlertCtr,animated: true)
        
        
        
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /* 利用指定的key從info dictionary取出照片 */
        if let pickedImage = info[.originalImage] as? UIImage { //.originalImage = Key
            imageView.image = pickedImage
            image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btChangeImage(_ sender: UIButton) {
        
        let alertCtr = UIAlertController(title: "請選擇方法", message: nil, preferredStyle: .actionSheet)
        
        let pickerAlertAction = UIAlertAction(title: "相簿挑選", style: .default) { (action) in
            
            // 製作一個UIImagePickerCtr
            let imagePicker = UIImagePickerController()
            /* 將UIImagePickerControllerDelegate、UINavigationControllerDelegate物件指派給UIImagePickerController */
            imagePicker.delegate = self
            
            /* 照片來源為相簿 */
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let takeAlertAction = UIAlertAction(title: "拍攝照片", style: .default) { (action) in
            // 製作一個UIImagePickerCtr
            let imagePicker = UIImagePickerController()
            /* 將UIImagePickerControllerDelegate、UINavigationControllerDelegate物件指派給UIImagePickerController */
            imagePicker.delegate = self
            
            /* 照片來源為相簿 */
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        alertCtr.addAction(takeAlertAction)
        alertCtr.addAction(pickerAlertAction)
        present(alertCtr,animated: true)
        
    }
    
    
}

extension SettingEditTVC{
    
    func getData() {
        
        if let user_id  = userDefaults.string(forKey: "user_id"){
            self.user_id = user_id
        }
        
        if let user_name = userDefaults.string(forKey: "user_name"){
            self.user_name = user_name
        }
        
        if let user_name = userDefaults.string(forKey: "user_name"){
            self.user_name = user_name
        }
        
        if let user_password = userDefaults.string(forKey: "user_pw"){
            self.user_password = user_password
        }
        
        if let user_email = userDefaults.string(forKey: "user_email"){
            self.user_email = user_email
        }
        
        user_private = userDefaults.integer(forKey: "user_private")
        
        
        if let image = userDefaults.data(forKey: "user_image") {
            self.image = UIImage(data: image)
        }
        
    }
    
    func setView() {
        
        lbID.text = user_id
        imageView.image = image
        tfPw.text = user_password
        tfName.text = user_name
        tfEmail.text = user_email
        
        if user_id.count == 16{
            tfPw.isEnabled = false
        }
        
        if user_private == 0 {
            swPrivate.setOn(false, animated: true)
        }
        
        
    }
    
    func saveUserInfoInUserDefault() {
        
        let userDefault = UserDefaults.standard
        
        userDefault.set(user_id, forKey: "user_id")
        userDefault.set(user_password, forKey: "user_pw")
        userDefault.set(user_name, forKey: "user_name")
        userDefault.set(user_email, forKey: "user_email")
        userDefault.set(user_private, forKey: "user_private")
        
        DispatchQueue.main.async {
            if let imageData = self.imageView.image!.jpegData(compressionQuality: 1.0) {
                userDefault.set(imageData, forKey: "user_image")
                // value,Key
            }
        }
        
        
        print("SaveInfo Success")
    }
    
    
}
