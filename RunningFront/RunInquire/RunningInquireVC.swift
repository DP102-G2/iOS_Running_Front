//
//  RunningInquireVC.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/24.
//  Copyright © 2019 G2. All rights reserved.
//

import UIKit
import Charts

class RunningInquireVC: UIViewController,ChartViewDelegate,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if pieRunList.count != 0 {
            return pieRunList.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let id = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunningInquireTVC") as! RunningInquireTVC
        cell.lbRun_Date.text = dateFormatter(pieRunList[id].run_date!)
        cell.lbRun_Time.text = "跑步時間：\(timeFormatter(Int(pieRunList[id].time)))"
        cell.lbRun_Carlorie.text = "消耗卡路里：\(String(doubleFormatter(pieRunList[id].calorie))) 卡"
        cell.lbRun_Distance.text = "跑步距離：\(String(doubleFormatter(pieRunList[id].distance))) 公尺"
        
        var image =  UIImage(systemName: "o.circle")
        var requestParam = [String:String]()
        requestParam["action"] = "getImage"
        requestParam["id"] = String(user_no)
        requestParam["run_no"] = String(pieRunList[id].runNo)
        print("userNo:\(String(user_no)),run_no:\(String(pieRunList[id].runNo))")
        
        executeTask(url!, requestParam) { (data, response, error) in
            if data != nil && error == nil{
                image = UIImage(data: data!)
                DispatchQueue.main.async {
                    cell.ivRun_Route.image = image
                }
            }
        }
        return cell
    }
    
    
    @IBOutlet var pickView: UIView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var dpDate: UIDatePicker!
    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    
    var allRunList = [Run]()
    var pieRunList = [Run]()
    
    let url = URL(string: "\(common_url)RunServlet")
    var user_no = 0
    var startDate : Date?
    var endDate : Date?
    
    
    var entries = [PieChartDataEntry]()
    var set = PieChartDataSet()
    var data = PieChartData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user_no = getUserNo()
        setPieDataDetail()
        getRunList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPickView()
    }
    
    @IBAction func btOpenPickerView(_ sender: UIButton) {
        pickerViewTrans(int: -200)
    }
    
    @IBAction func btSelectedDate(_ sender: UIButton) {
        pickerViewTrans(int: 100)
        startDate = startOfDayFormatter(date: dpDate.date)
        endDate = getEndDate(selected: startDate!, limited: allRunList[allRunList.count-1].run_date!)
        lbDate.text = getWeekStr(selected: startDate!, endDate: endDate!)
        changePieChartData()
        self.tableView.reloadData()

    }
    
}


extension RunningInquireVC {
    
    
    func setPieDataDetail() {
        
        set.drawIconsEnabled = false
        set.sliceSpace = 5
        set.valueFont = .systemFont(ofSize: 12)
        set.drawValuesEnabled = false
        set.colors = ChartColorTemplates.colorful()
        
        data.setValueFont(.systemFont(ofSize: 12, weight: .light))
        data.setValueTextColor(.white)
        
        chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        chartView.legend.enabled = false
        chartView.delegate = self
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        chartView.notifyDataSetChanged()
        chartView.entryLabelColor = .black
        
    }
    
    func changePieChartData() {
        entries.removeAll()
        data.clearValues()
        pieRunList.removeAll()
        allRunList.forEach { (run) in
            
            if startDate != nil{
                if run.run_date!.compare(startDate!) == .orderedDescending && run.run_date!.compare(endDate!) == .orderedAscending {
                    entries.append(PieChartDataEntry(value: run.distance, label: weekdayFormatter(run.run_date!)))
                    pieRunList.append(run)
                }
            }
        }
        
        set.replaceEntries(entries)
        data.addDataSet(set)
        chartView.data = data
        
        
        let stringWithAttribute = NSAttributedString(string: "距離：\n\(String(Run.getDistanceSum(pieRunList)))公尺",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0)])
        chartView.centerAttributedText = stringWithAttribute
        
        
    }
    
    
    func setPickView(){
        view.addSubview(pickView)
        pickView.translatesAutoresizingMaskIntoConstraints = false
        pickView.heightAnchor.constraint(equalToConstant: 128).isActive = true
        pickView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 0).isActive = true
        pickView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        let c = pickView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 128)
        c.identifier = "bottom"
        c.isActive = true
    }
    
    func pickerViewTrans(int:Int) {
        for c in view.constraints{
            if c.identifier == "bottom"{
                c.constant = CGFloat(int)
                break
            }
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setDatePicker(_ start:Date,_ end:Date) {
        self.datePicker.minimumDate = start
        self.datePicker.maximumDate = end
    }
    
    func getRunList() {
        var requestParam = [String:String]()
        requestParam["action"] = "getRunList"
        requestParam["user_no"] = String(user_no)
        
        executeTask(url!, requestParam) { (data, response, error) in
            let jsonDecoder = getDateDecoder()
            self.allRunList = try! jsonDecoder.decode([Run].self, from: data!)
            print("runList.count: \(String(self.allRunList.count))")
            
            DispatchQueue.main.async {
                // 設定datePicker最大與最小時間
                self.restartView()
            }
            
        }
    }
    
    func restartView() {
        endDate = getStartEndDate(endDate: allRunList[allRunList.count-1].run_date!)
        startDate = getStartDate(endDate: endDate!)
        setDatePicker(allRunList[0].run_date!, allRunList[allRunList.count-1].run_date!)
        changePieChartData()
        lbDate.text = getWeekStr(selected: startDate!, endDate: endDate!)
        tableView.reloadData()
    }
    
    
}
