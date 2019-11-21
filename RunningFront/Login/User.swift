//
//  Login.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/20.
//  Copyright © 2019 G2. All rights reserved.
//

import Foundation
class User :Codable {
    
    var no : Int?
    var id : String?
    var name : String?
    var password : String?
    
    init(_ id:String,_ password:String) {
        self.id = id
        self.password = password
    }
    
    init(_ no:Int,_ id:String,_ name:String,_ password:String) {
        self.no = no
        self.id = id
        self.name = name
        self.password = password
    }
    
}
