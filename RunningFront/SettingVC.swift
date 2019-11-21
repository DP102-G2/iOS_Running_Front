//
//  SettingVC.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/19.
//  Copyright © 2019 G2. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

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

extension SettingVC{
    func setBarButtonItem() {
        let Run = UIBarButtonItem(image: UIImage(named: "item_ic_Run"), style: .done, target: self, action: #selector(naviToRun))
        let shop = UIBarButtonItem(image: UIImage(named: "item_ic_Shop"), style: .done, target: self, action: #selector(naviToShop))
        navigationItem.rightBarButtonItems = [Run,shop]
    }
    
    @objc  func naviToRun() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let shopTabBar = storyboard.instantiateViewController(identifier: "runTabBar") as! UITabBarController
        
        shopTabBar.modalPresentationStyle = .fullScreen
        navigationController?.removeFromParent()
        present(shopTabBar, animated: true, completion: nil)
    }
    
    @objc  func naviToShop() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let shopTabBar = storyboard.instantiateViewController(identifier: "shopTabBar") as! UITabBarController
        shopTabBar.modalPresentationStyle = .fullScreen
        navigationController?.removeFromParent()
        present(shopTabBar, animated: true, completion: nil)
    }
}
