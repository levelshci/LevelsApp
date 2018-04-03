//
//  FirstViewController.swift
//  Levels
//
//  Created by Jonathan Pereyra on 3/31/18.
//  Copyright © 2018 Jonathan Pereyra. All rights reserved.
//

import UIKit
import Charts

class HomeViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    
    var months: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Data
        months = ["Food", "Gas", "Overall"]
        let actual = [15.0, 25.0, 65.0]
        
        // Remove Gridlines and axis labels
        barChartView.xAxis.enabled = false
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.drawBordersEnabled = false
        barChartView.minOffset = 0

        // Remove legend
        barChartView.legend.enabled = false
        
        // Set Chart Description to nil (no descrip.)
        barChartView.chartDescription = nil
        
        // Populate the Chart
        setChart(dataPoints: months, values: actual)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        // Array for Bar Colors
        var barColors = [UIColor]()
        
        // Store Data
        var dataEntries: [BarChartDataEntry] = []
        
        // User set limits for budgets
        let cap = [20.0, 45.0, 100.0]
        
        
        for i in 0..<dataPoints.count {
            
            let dataEntry = BarChartDataEntry(x: Double(i), yValues: [values[i], cap[i]-values[i]])
            
            dataEntries.append(dataEntry)
            
            // Set Bar color for value
            barColors.append(setColor(value: cap[i]-values[i]))
            
            // Top of bar is "fillable"
            barColors.append(UIColor.clear)
            
            // Still need to handle over budget
        }
        
        // Populate Data into Chart
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Units Sold")
        chartDataSet.colors = barColors
        
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        // Fillable aesthetic (add a border) around entire bar
        chartDataSet.barBorderWidth = 1
        chartDataSet.barBorderColor = UIColor.white
        
    }
    

    // Function to determine bar color
    func setColor(value: Double)-> UIColor{
        let diff = value
        if(diff < 10){
            return UIColor.init(red: 234/255, green: 65/255, blue: 247/255, alpha: 1.0)
        }
        
        else if (diff < 30){
            return UIColor.init(red: 255/255, green: 254/255, blue: 132/255, alpha: 1.0)
        }
        else{
            return UIColor.init(red: 70/255, green: 254/255, blue: 208/255, alpha: 1.0)
        }
    }
}

