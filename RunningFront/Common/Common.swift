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

