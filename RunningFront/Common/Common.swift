import Foundation
import UIKit

/* 實機 URL */
// let URL_SERVER = "http://192.168.0.101:8080/RunningWeb/"

/* 模擬器 */
let common_url = "http://127.0.0.1:8080/RunningWeb/"


/* ==================== * ==================== */


func dateFormat(date: Date) -> String {
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd"
    return format.string(from: date)
}


/* ==================== * ==================== */

/**
 * 連線 Servlet 程式
 * - Parameters url_server: 連線網址
 * - Parameters requestParam: 連線請求的參數
 */
func executeTask(_ url_server: URL, _ requestParam: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    /* requestParam 值為 Any 就必須使用 JSONSerialization.data()
     * 而非 JSONEncoder.encode() */
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
    /* 建立連線資料，放入請求資訊
     * completionHandler 代表「當請求完後要接續處理的事情」，由此func的建構式來置入 */
    let task = sessionData.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
}

/**
 * 類似 Android 的 showToast
 - Parameter message:        想要呈現的文字
 - Parameter viewController: 當前的 ViewController，一般只要輸入 self 即可
 */
func showSimpleAlert(message: String, viewController: UIViewController) {
    let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let cancel = UIAlertAction(title: "確認", style: .default)
    alertController.addAction(cancel)
    /* 呼叫present()才會跳出Alert Controller */
    viewController.present(alertController, animated: true, completion:nil)
}


/* ==================== 存取會員資訊 ==================== */

/**
 * 抓取偏好設定裡面的 user_no
 - Returns: 會員編號的 Int
 * ```
 * let user_no = getUserNo()
 * ```
 */
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

/**
 * 呼叫此函式即登出會員
 - Parameter VC: 當前使用的 ViewController
 - Returns:      判斷是否已經會登出會員的 Bool
 */
func logout(VC: UIViewController) -> Bool {
    let defaults = UserDefaults.standard
    
    defaults.set(0, forKey: "user_no")
    
    let user_no = getUserNo()
    if user_no == 0{
        return true
    }
    return false
}


/* ==================== 資料格式化 ==================== */

/**
 * 將原本的 Double 取到小數點後第二位
 - Parameter double: 原本的數字（Double型別）
 - Returns:          取至小數點後第二位的 Double
 * ```
 * let double_origin = 1234.5678
 * let double_format = doubleFormatter(double_origin)
 * ```
 */
func doubleFormatter(_ double:Double) -> Double {
    let nsNumber = NSNumber(value: double)
    let customerFormatter = NumberFormatter()
    customerFormatter.positiveFormat = "#,##0.##"
    
    return Double(customerFormatter.number(from: customerFormatter.string(from: nsNumber)!)!)
}

/**
 * 將資料庫裡的跑步時間格式化，變成 oo小時oo分鐘oo秒。
 * 由於資料庫的數值是 double 形式，因此記得要轉型
 - Parameter time: 秒數的 Int
 - Returns:        oo 小時 oo 分鐘 oo 秒
 - Warning:        由於資料庫的數值是 double 形式，記得要轉型
```
let str = doubleFormatter(Int(原數值))
```
 */
func timeFormatter(_ time: Int) -> String {
    
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


/**
將資料庫裡的跑步日期格式化，變成"yyyy年MM月dd日，HH點 mm分"，
由於資料庫的數值是double形式，因此記得要轉型
````
let str = doubleFormatter(原數值)
````
*/
func dateFormatter(_ date:Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy年MM月dd日，HH點 mm分"
    let weekDay = dateFormatter.string(from: date)
    return weekDay
}

/**
 * 輸入 date 抓取目前週幾
 */
func weekdayFormatter(_ date:Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    let weekDay = dateFormatter.string(from: date)
    return weekDay
}

/**
 * 若抓取伺服器的 timestamp 必須使用此 JSONDecoder
 * ```
 * let dateDecoder = getDateDecoder()
 * ```
 */
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


/* ==================== * ==================== */

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

func dataToDictionary(data:Data) ->Dictionary<String, Any>?{
    do{
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        let dic = json as! Dictionary<String, Any>
        return dic
    }catch _ {
        print("失败")
        return nil
    }
}

func getAPIData(_ url:URL , completionHandler:@escaping (Data?, URLResponse?, Error?) -> Void) {
    
    let task = URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
    task.resume()
    
}
