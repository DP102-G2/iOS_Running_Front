//
//  Order.swift
//  RunningFront
//
//  Created by hys737577 on 2019/12/3.
//  Copyright © 2019 G2. All rights reserved.
//

import Foundation

class Order: Codable {
    var order_no: Int
    var payment_methon: Int?
    var detail: String?
    var order_date: Date?
    var order_money: Int?
    var order_status: String?
    var product_no: String?
    var qty: Int?
    var order_price: Int?
    var user_no: Int?
    


    
    public init(_ order_no: Int, _ payment_methon: Int, _ detail: String, _ order_date: Date, _ order_money: Int, _ order_status: String, _ product_no: String, _ qty: Int,_ order_price: Int, _ user_no: Int ) {
        self.order_no = order_no
        self.payment_methon = payment_methon
        self.detail = detail
        self.order_date = order_date
        self.order_money = order_money
        self.order_status = order_status
        self.product_no = product_no
        self.qty = qty
        self.order_price = order_price
        self.user_no = user_no
    }
    
//    var dateStr: String {
//        if date != nil {
//            let format = DateFormatter()
//            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            return format.string(from: date!)
//        } else {
//            return ""
//        }
//    }
}

