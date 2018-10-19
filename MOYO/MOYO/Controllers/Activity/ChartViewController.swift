//
//  ChartViewController.swift
//  MOYO
//
//  Created by Corey S on 9/15/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import SwiftCharts
import SnapKit
import HealthKit
import KRProgressHUD

class ChartViewController: UIViewController {
    var chartView: UIView? = nil
    var chart : Chart? = nil
    var data = [(String,Double)]()
    override func viewDidAppear(_ animated: Bool) {
        viewWillLayoutSubviews()
        title = NSLocalizedString("Activity", comment: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Activity", comment: "")
        
    }
    override func viewWillLayoutSubviews() {
        createGrapth()
    }
    public func createGrapth(){
        if chartView != nil {
            chartView?.removeFromSuperview()
            chartView = nil
            self.chart = nil
        }
        if data.count == 0 {
            return
        }
        guard let max = data.max(by: { (lv, rv) -> Bool in
            return lv.1 < rv.1
        }) else {
            return
        }
        let maxv = (max.1) + (max.1 * 0.10)
        let chartConfig = BarsChartConfig(
            valsAxisConfig: ChartAxisConfig(from: 0, to:maxv , by: round(round(maxv/10)/10)*10)
        )
        
        let frame = CGRect(x: 0, y: 0, width: 340, height: 610)
        
        self.chart = BarsChart(
            frame: frame,
            chartConfig: chartConfig,
            xTitle: "# Of Day",
            yTitle: "# Of Steps",
            bars: data,
            color: UIColor.red,
            barWidth: 12
        )
        
        self.view.addSubview(chart!.view)
        self.chartView = chart!.view
        chartView!.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(50)
        }
        chartView!.clipsToBounds = false
    }
    // steps
    let healthkitStore = HKHealthStore()
    
    override func viewWillAppear(_ animated: Bool) {
        
        let healthKitTypes: Set = [
            // access step count
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        ]
        healthkitStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (bool, error) in
            if let e = error {
                print("Something went wrong during authorization \(e.localizedDescription)")
            } else {
                print("Authorization complete.")
                self.getSteps()
            }
        }
    }
    
    
    func getSteps() {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let calendar = Calendar.current
        let now = Date()
        let startDay = calendar.startOfDay(for: now.addingTimeInterval((-9*24*60*60)))
        let interval = DateComponents(calendar: nil,
                                      timeZone: nil,
                                      era: nil,
                                      year: nil,
                                      month: nil,
                                      day: 1,
                                      hour: nil,
                                      minute: nil,
                                      second: nil,
                                      nanosecond: nil,
                                      weekday: nil,
                                      weekdayOrdinal: nil,
                                      quarter: nil,
                                      weekOfMonth: nil,
                                      weekOfYear: nil,
                                      yearForWeekOfYear: nil)
        let query = HKStatisticsCollectionQuery(quantityType: stepsQuantityType,
                                                quantitySamplePredicate: nil,
                                                options: .cumulativeSum,
                                                anchorDate: startDay,
                                                intervalComponents: interval)
        query.initialResultsHandler = {
            query, results, error in
            
            guard let statsCollection = results else {
                return
            }
            // data
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            formatter.timeZone = TimeZone.current
            statsCollection.enumerateStatistics(from: startDay, to: Date.distantFuture) { [unowned self] statistics, stop in
                if let quantity = statistics.sumQuantity() {
                    let date = statistics.startDate
                    let value = quantity.doubleValue(for: HKUnit.count())
                    let label = formatter.string(from: date)
                    print("date:\(date)\tlabel:\(label)\tvalue:\(value)")
                    self.data.append((label, value))
                    DispatchQueue.main.async {
                        KRProgressHUD.dismiss()
                        self.createGrapth()
                    }
                }
            }
        }
        DispatchQueue.main.async {
            KRProgressHUD.show(withMessage: "Collecting data..", completion: nil)
        }
        healthkitStore.execute(query)
    }
    
}
