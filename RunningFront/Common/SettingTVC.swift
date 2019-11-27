//
//  SettingTVC.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/26.
//  Copyright © 2019 G2. All rights reserved.
//

import UIKit

class SettingTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtonItem()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


}

extension SettingTVC{
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
