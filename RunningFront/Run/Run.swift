//
//  Run.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/22.
//  Copyright © 2019 G2. All rights reserved.
//

import Foundation

class Run: Codable {
    
    var runNo  = 0
    var userNo : Int
    var run_date : Date?
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
    
    init(_ runNo:Int,_ userNo:Int,run_date:Date,_ time:Double,_ distance:Double,_ calorie:Double,_ speed:Double) {
        self.runNo = runNo
        self.userNo = userNo
        self.run_date = run_date
        self.time = time
        self.distance = distance
        self.calorie = calorie
        self.speed = speed
    }
    
    static func getDistanceSum(_ runList:[Run]) -> Double{
        
        var distanceSum = 0.0
        runList.forEach { (run) in
            distanceSum += run.distance
        }
        
        return doubleFormatter(distanceSum)
    }
    static func getCalories(_ runList:[Run]) -> Double{
        
        var calories = 0.0
        runList.forEach { (run) in
            calories += run.calorie
        }
        
        return doubleFormatter(calories)
    }
    
    static func getTimeSum(_ runList:[Run]) -> Double{
        
        var timeSum = 0.0
        runList.forEach { (run) in
            timeSum += run.time
        }
        
        return doubleFormatter(timeSum)
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
