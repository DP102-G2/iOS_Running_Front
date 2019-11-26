//
//  SettingMainTVC.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/25.
//  Copyright © 2019 G2. All rights reserved.
//

import UIKit

class SettingMainTVC: UITableViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtonItem()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        switch index {
        case 1:
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SettingEditTVC") as! UITableViewController
            navigationController?.pushViewController(VC, animated: true)
        case 3:
            if logout(VC: self) == false{
                naviToLogin(VC: self)
            }
        default:
            break
        }
        
    }
    
    
    
}

extension SettingMainTVC{
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
