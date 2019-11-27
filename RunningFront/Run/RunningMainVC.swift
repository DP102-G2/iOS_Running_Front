//
//  ViewController.swift
//  RunningFront
//
//  Created by FanFan on 2019/11/18.
//  Copyright © 2019 G2. All rights reserved.
//

import UIKit
import Charts

class RunningMainVC: plateVC,ChartViewDelegate {
    
    var user_no = 0
    var runList = [Run]()
    let url = URL(string: "\(common_url)RunServlet")
    
    @IBOutlet weak var lbTimeSum: UILabel!
    @IBOutlet weak var lbCarlories: UILabel!
    @IBOutlet weak var chartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        user_no = getUserNo()
        if user_no == 0 {
            naviToLogin(VC: self)
        }
        getRunList()

    }
}


extension RunningMainVC {
    
    func setLable()  {
        
        lbCarlories.text = "本週消耗卡路里： \(String(Run.getCalories(runList))) 卡"
        lbTimeSum.text = "本週運動： \(timeFormatter(Int(Run.getTimeSum(runList)))) "

        
    }
    
    func getRunList() {
        var requestParam = [String:String]()
        requestParam["action"] = "getWeekRunList"
        requestParam["userNo"] = String(user_no)
        
        executeTask(url!, requestParam) { (data, response, error) in
            let jsonDecoder = getDateDecoder()
            if let runs = try? jsonDecoder.decode([Run].self, from: data!){
            self.runList = runs
            print("runList.count: \(String(self.runList.count))")
            
            DispatchQueue.main.async {
                self.setPieChartView()
                self.setLable()
            }
            }
        }
    }
    
    func setPieChartView() {
        
        var entries = [PieChartDataEntry]()
        runList.forEach { (run) in
            entries.append(PieChartDataEntry(value: run.distance, label: weekdayFormatter(run.run_date!)))
        }
        
        let set = PieChartDataSet(entries: entries, label: "LabelString")
        set.drawIconsEnabled = false
        set.sliceSpace = 5
        set.colors = ChartColorTemplates.colorful()
        set.valueFont = .systemFont(ofSize: 20)
        set.drawValuesEnabled = false
        
        let data = PieChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 20, weight: .light))
        data.setValueTextColor(.white)
        
        let stringWithAttribute = NSAttributedString(string: "本週跑步累計：\n\(String(Run.getDistanceSum(runList)))公尺",
                                                     attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0)])
        chartView.centerAttributedText = stringWithAttribute
        chartView.entryLabelColor = .black
        chartView.entryLabelFont = .systemFont(ofSize: 20, weight: .light)
        chartView.data = data
        chartView.legend.enabled = false
        chartView.delegate = self
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        chartView.notifyDataSetChanged()
    }
    
    
//    if let dataSet = chartView.data?.dataSets[highlight.dataSetIndex]{
//        dataSet.entryIndex(entry: entry)}
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        showSimpleAlert(message: "跑步時間：\(dateFormatter(runList[Int(highlight.x)].run_date!))\n跑步距離：\(runList[Int(highlight.x)].distance) 公尺", viewController: self)
    }
    
    
}
