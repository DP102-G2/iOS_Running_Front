//
//  ViewController.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/18.
//  Copyright © 2019 G2. All rights reserved.
//

import UIKit

class RunningMainVC: UIViewController {
    
    var user_no = 0
    
    
    
    @IBAction func btLgout(_ sender: UIButton) {
        
        if logout(VC: self) == false{
            naviToLogin(VC: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

//        user_no = getUserNo()
//        
//        if user_no == 0 {
//            naviToLogin(VC: self)
//        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtonItem()
    }
}


extension RunningMainVC {
    
    func setBarButtonItem() {
        let shop = UIBarButtonItem(image: UIImage(named: "item_ic_Shop"), style: .done, target: self, action: #selector(naviToShop))
        let set = UIBarButtonItem(image: UIImage(named: "item_ic_Set"), style: .done, target: self, action: #selector(naviToSetting))
        navigationItem.rightBarButtonItems = [set,shop]
    }
    
    @objc  func naviToShop() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let shopTabBar = storyboard.instantiateViewController(identifier: "shopTabBar") as! UITabBarController
        shopTabBar.modalPresentationStyle = .fullScreen
        navigationController?.removeFromParent()
        present(shopTabBar, animated: true, completion: nil)
    }
    @objc  func naviToSetting() {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let setTabBar = storyboard.instantiateViewController(identifier: "setTabBar") as! UINavigationController
        setTabBar.modalPresentationStyle = .fullScreen
        navigationController?.removeFromParent()
        present(setTabBar, animated: true, completion: nil)
    }
    
    
}
