import Foundation
import UIKit

// 實機
// let URL_SERVER = "http://192.168.0.101:8080/RunningWeb/"
// 模擬器

func dateFormat(date:Date) -> String {
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd"
    return format.string(from: date)
}

let common_url = "http://127.0.0.1:8080/RunningWeb/"

func executeTask(_ url_server: URL, _ requestParam: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    
    // requestParam值為Any就必須使用JSONSerialization.data()，而非JSONEncoder.encode()
    let jsonData = try! JSONSerialization.data(withJSONObject: requestParam)
    // 宣告請求，並且為其設定相關數值
    var request = URLRequest(url: url_server)
    request.httpMethod = "POST"
    // 不使用暫存數據
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    // 存入請求時須附帶的資料
    request.httpBody = jsonData
    // 創建一個訪問的會議及單獨溝通的空間
    let sessionData = URLSession.shared
    // 建立連線資料，放入請求資訊，completionHandler代表「當請求完後要接續處理的事情」，由此func的建構式來置入
    let task = sessionData.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
}

func showSimpleAlert(message: String, viewController: UIViewController) {
    let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let cancel = UIAlertAction(title: "確認", style: .default)
    alertController.addAction(cancel)
    /* 呼叫present()才會跳出Alert Controller */
    viewController.present(alertController, animated: true, completion:nil)
}

func getUserNo() -> Int {
    var user_no = 0
    if let noStr = UserDefaults.standard.value(forKey: "user_no") {
        print("user_no: \(noStr)")
        user_no = noStr as! Int
    } else {
        user_no = 0
    }
    return user_no
}

func logout(VC:UIViewController) -> Bool {
    let domain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: domain)
    UserDefaults.standard.synchronize()
    print(String(UserDefaults.standard.dictionaryRepresentation().keys.count))
    
    if UserDefaults.standard.dictionaryRepresentation().keys.count == 0{
        showSimpleAlert(message: "登出成功", viewController: VC)
        return true
    }
    return false
}


func doubleFormatter(double:Double) -> Double {
    let nsNumber = NSNumber(value: double)
    let customerFormatter = NumberFormatter()
    customerFormatter.positiveFormat = "#,##0.##"
    
    return Double(customerFormatter.number(from: customerFormatter.string(from: nsNumber)!)!)
}

func timeFormatter(_ time:Int) -> String {
    
    let seconds = time % 60
    let mins = time / 60
    let hour = time / 3600
    
    let customerFormatter = NumberFormatter()
    customerFormatter.positiveFormat = "00.##"
    
    let str = "\(customerFormatter.string(from: NSNumber(value: hour))!) 小時 \(customerFormatter.string(from: NSNumber(value: mins))!) 分鐘 \(customerFormatter.string(from: NSNumber(value: seconds))!) 秒"
    
    return str
}

func speedFormatter(_ speed:Double) -> String {
    
    let customerFormatter = NumberFormatter()
    customerFormatter.positiveFormat = "0.##"
    
    let str = customerFormatter.string(from: NSNumber(value: speed))!
    return str
}



func dateFormatter(_ date:Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy年MM月dd日，HH點 mm分"
    let weekDay = dateFormatter.string(from: date)

    return weekDay
}

func weekdayFormatter(_ date:Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    let weekDay = dateFormatter.string(from: date)

    return weekDay
}

func getDateDecoder() -> JSONDecoder {
    let formatter = DateFormatter()
    var decoder : JSONDecoder{
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom{ decoder  in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            formatter.locale = Locale(identifier: "zh_TW")
            formatter.dateFormat = "yyyyMMddHHmmss"
            if let date = formatter.date(from: dateString){
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date String \(dateString)")
        }
        return decoder
    }
    return decoder
}


func startOfDayFormatter(date:Date) -> Date{
    
    var cal = Calendar.current
    cal.locale = Locale(identifier: "zh_TW")
    return Calendar.current.startOfDay(for: date)
}

func getStartEndDate(endDate:Date) -> Date {
    
    var StartEndDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate)
    StartEndDate = Calendar.current.startOfDay(for: StartEndDate!)
    
    return StartEndDate!
}

func getStartDate(endDate:Date) -> Date {
    
    var startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate)
    startDate = Calendar.current.startOfDay(for: startDate!)
    
    return startDate!
}

func getEndDate(selected:Date,limited:Date) -> Date {
    
    let endDate = Calendar.current.date(byAdding: .day, value: 8, to: selected)
    if endDate!.compare(limited) == .orderedAscending {
        return Calendar.current.startOfDay(for: endDate!)
    }
    
    let limitesDate = Calendar.current.date(byAdding: .day, value: 1, to: limited)
    
    return Calendar.current.startOfDay(for: limitesDate!)
    
}

func getWeekStr(selected:Date,endDate:Date) -> String {
    
    let nEndDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate)
    let formatter = DateFormatter()
    formatter.dateFormat = "MM月dd日"
    let startStr = formatter.string(from: selected)
    let endStr = formatter.string(from: nEndDate!)    
    return "\(startStr) 至 \(endStr)"
}

