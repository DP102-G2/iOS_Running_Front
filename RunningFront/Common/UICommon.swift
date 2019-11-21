//
//  UICommon.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/19.
//  Copyright © 2019 G2. All rights reserved.
//

import Foundation
import UIKit

    
func naviToLogin(VC:UIViewController) {
    let storyboard = UIStoryboard(name: "Login", bundle: nil)
    let LoginNC = storyboard.instantiateViewController(identifier: "LoginNC") as! UINavigationController
    LoginNC.modalPresentationStyle = .fullScreen
    VC.navigationController?.removeFromParent()
    VC.present(LoginNC, animated: true, completion: nil)
}
    
func naviToShop(VC : UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let shopTabBar = storyboard.instantiateViewController(identifier: "shopTabBar") as! UITabBarController
        shopTabBar.modalPresentationStyle = .fullScreen
        VC.navigationController?.removeFromParent()
        VC.present(shopTabBar, animated: true, completion: nil)
    }
    
func naviToRun(VC : UIViewController) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let shopTabBar = storyboard.instantiateViewController(identifier: "runTabBar") as! UITabBarController
    shopTabBar.modalPresentationStyle = .fullScreen
    VC.navigationController?.removeFromParent()
    VC.present(shopTabBar, animated: true, completion: nil)
}
