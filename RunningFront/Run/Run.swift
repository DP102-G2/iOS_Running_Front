//
//  Run.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/22.
//  Copyright © 2019 G2. All rights reserved.
//

import Foundation

class Run: Codable {
    
    var userNo : Int
//    let timestamp = NSDate().timeIntervalSince1970
    var time : Double
    var distance : Double
    var calorie : Double
    var speed : Double
    
    init(_ userNo:Int,_ time:Double,_ distance:Double,_ calorie:Double,_ speed:Double) {
        self.userNo = userNo
        self.time = time
        self.distance = distance
        self.calorie = calorie
        self.speed = speed
    }
    
    
//    int runNo;
//    int userNo;
//    byte[] route;
//    Timestamp run_date;
//    double time;
//    double distance;
//    double calorie;
//    double speed;
}
