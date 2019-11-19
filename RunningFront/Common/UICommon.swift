//
//  UICommon.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/19.
//  Copyright © 2019 G2. All rights reserved.
//

import Foundation
import UIKit

public class UICommon {
@objc static func naviToShop(VC : RunningMainVC) {
        let shopTabBar = VC.storyboard?.instantiateViewController(identifier: "shopTabBar") as! ShopTBC
        shopTabBar.modalPresentationStyle = .fullScreen
        VC.navigationController?.removeFromParent()
        VC.present(shopTabBar, animated: true, completion: nil)
        
    }
    
static func setRunTabItem(VC : UIViewController)  {
        
        
        let shop = UIBarButtonItem(image: UIImage(named: "item_ic_Shop"), style: .done, target: VC, action: #selector(UICommon.naviToShop(VC:)))
        let set = UIBarButtonItem(image: UIImage(named: "item_ic_Set"), style: .done, target: VC, action: nil)
        VC.navigationItem.rightBarButtonItems = [set,shop]
        
    }
    
    
}





func setShopTabItem(VC : UIViewController)  {
    let run = UIBarButtonItem(image: UIImage(named: "item_ic_Run"), style: .done, target: VC, action: nil)
    let set = UIBarButtonItem(image: UIImage(named: "item_ic_Set"), style: .done, target: VC, action: nil)
    VC.navigationItem.rightBarButtonItems = [set,run]
}


