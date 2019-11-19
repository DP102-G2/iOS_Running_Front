//
//  ShopBBI.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/19.
//  Copyright © 2019 G2. All rights reserved.
//

import UIKit

class ShopBBI: UIBarButtonItem {

    @objc static func naviToShop(VC : ViewController) {
        let shopTabBar = VC.storyboard?.instantiateViewController(identifier: "shopTabBar") as! ShopTBC
        shopTabBar.modalPresentationStyle = .fullScreen
        VC.navigationController?.removeFromParent()
        VC.present(shopTabBar, animated: true, completion: nil)
        
    }
    
    
}
