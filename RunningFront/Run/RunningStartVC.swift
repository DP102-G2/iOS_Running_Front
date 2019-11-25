//
//  RunningStartVC.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/21.
//  Copyright © 2019 G2. All rights reserved.
//

import UIKit
import MapKit


class RunningStartVC: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let url = URL(string: "\(common_url)RunServlet")
    
    let locationManager = CLLocationManager()
    var spanList = [CLLocationCoordinate2D]()
    var annList = [MKAnnotation]()
    var user_no = 0
    var runStatus = false
    var time = 0
    var distance = 0.0
    var calorie = 0.0
    var speed = 0.0
    var timer = Timer()
    var image : UIImage?

    
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbDistance: UILabel!
    @IBOutlet weak var lbCalorie: UILabel!
    @IBOutlet weak var lbSpeed: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        user_no = getUserNo()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setlocalManager()
        
    }
    
    @IBAction func btRunStatus(_ sender: UIButton) {
        
        if !runStatus{
            runStatus = true
            sender.setTitle("結束跑步", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startRun), userInfo: nil, repeats: true)
            
        }else{
            runStatus = false
            timer.invalidate()
            
            let run = Run(user_no, Double(time), distance, calorie, speed)
            
            var requestParam = [String:String]()
            requestParam["action"] = "insertRun"
            requestParam["run"] = try? String(data: JSONEncoder().encode(run),encoding: .utf8)
            image = getMapImage(map: mapView)
            
            requestParam["imageBase64"] = self.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
            executeTask(url!, requestParam) { (data, response, error) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    showSimpleAlert(message: "儲存成功", viewController: self)
                }
                
            }
            
            
        }
        
    }
    
    @objc func startRun() {
        time += 1
        lbTime.text = "時間：\(timeFormatter(time))"
        if spanList.count > 3{
            distance = doubleFormatter(double: getDistance(from: spanList[0], to: spanList[spanList.count-1]))
        }
        
        lbDistance.text = "距離：\(distance) 公尺"
        
        speed = doubleFormatter(double: (distance / Double(time) * 3600.0 / 1000.0))
        lbSpeed.text = "速度：\(speedFormatter(speed)) 小時/公里"
        calorie = doubleFormatter(double: 70.0 * (Double(time) / 3600.0) * 30.0 / (Double(time) / Double(distance) * 400.0 / 60.0))
        lbCalorie.text = "卡路里：\(speedFormatter(calorie)) 卡"
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        // 分成有圖針跟沒有圖針 MKAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView?.image = UIImage(systemName: "multiply.circle.fill")
        annotationView?.centerOffset = CGPoint(x: -10, y: -10)// 设置大头针中心偏移量
        
        
        if annotation.title == "point"{
            annotationView?.image = UIImage(named: "category_1")// 设置打头针的图片
        }
        
        return annotationView
    }
    
    
    // 更新位置時自動呼叫此func
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !mapView.isUserLocationVisible {
            mapView.setCenter(userLocation.coordinate, animated: true)
        }
        
        if runStatus == true{
            
            let userNow = CLLocationCoordinate2D(latitude:         userLocation.coordinate.latitude
                , longitude:userLocation.coordinate.longitude)
            
            spanList.append(userNow)
            

            
            // 製作線條的部分，使用addOverlay會自動呼叫rendererFor
            let user_ann = MKPointAnnotation() //設定標記跟點位
            user_ann.coordinate = CLLocationCoordinate2D(latitude:userLocation.coordinate.latitude, longitude:userLocation.coordinate.longitude)
            user_ann.title = "point"
            mapView.addAnnotation(user_ann)
            
            if spanList.count > 4 {
            let polyline = MKPolyline(coordinates: spanList, count: spanList.count-2)
            mapView.addOverlay(polyline)
                if getDistance(from: spanList[0], to: spanList[spanList.count-1]) > 50 && spanList.count % 3 == 0 {
            mapView.showAnnotations(mapView.annotations, animated: true)
            }
            
            }
        }
    }
    
    
    // 當製作疊加時會自動呼叫此func
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRender = MKPolylineRenderer(overlay: overlay)
            polylineRender.strokeColor = UIColor.red
            polylineRender.lineWidth = 5
            return polylineRender
        }
        return overlay as! MKOverlayRenderer
    }
    
}

extension RunningStartVC {
    
    // 設定管理器
    func setlocalManager() {
        // 重置
        locationManager.requestWhenInUseAuthorization()
        // 設定距離多遠會啟動updateㄟ
        locationManager.distanceFilter = 5
        // 開始偵測
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        var region = MKCoordinateRegion()
        
        region.span = span
        mapView.setRegion(region, animated: true)
        mapView.regionThatFits(region)
        
        // 即使開設權限，還是可以設定是否要繼續追蹤
        mapView.showsUserLocation = true
    }
    
    // 抓取Map的照片
    func getMapImage(map:MKMapView) -> UIImage {
        
        let view = map.snapshotView(afterScreenUpdates: false)
        
        let renderer = UIGraphicsImageRenderer(size: view!.bounds.size)
        let image = renderer.image(actions: { (context) in
            view!.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        })
        
        return image
    }
    
    func getDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
    
    
}
