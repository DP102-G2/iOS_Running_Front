//
//  ShopMainVC.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/19.
//  Copyright © 2019 G2. All rights reserved.
//

import UIKit

class ShopMainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtonItem()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



extension ShopMainVC {
    
    func setBarButtonItem() {
        let Run = UIBarButtonItem(image: UIImage(named: "item_ic_Run"), style: .done, target: self, action: #selector(naviToRun(VC:)))
        let set = UIBarButtonItem(image: UIImage(named: "item_ic_Set"), style: .done, target: self, action: #selector(naviToSetting))
        navigationItem.rightBarButtonItems = [set,Run]
    }
    
    @objc  func naviToRun(VC : UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let shopTabBar = storyboard.instantiateViewController(identifier: "runTabBar") as! RunningTBC
        shopTabBar.modalPresentationStyle = .fullScreen
        navigationController?.removeFromParent()
        present(shopTabBar, animated: true, completion: nil)
    }
    
    @objc  func naviToSetting() {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let setTabBar = storyboard.instantiateViewController(identifier: "setTabBar") as! SettingNC
        setTabBar.modalPresentationStyle = .fullScreen
        navigationController?.removeFromParent()
        present(setTabBar, animated: true, completion: nil)
    }
    
}
