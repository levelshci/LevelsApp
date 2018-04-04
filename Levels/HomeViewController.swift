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
    
    var categories: [String]!
    var actual: [Double]!
    var darkRedColor = UIColor.init(red: 192/255, green: 53/255, blue: 202/255, alpha: 1.0)
    var redColor = UIColor.init(red: 234/255, green: 65/255, blue: 247/255, alpha: 1.0)
    var yellowColor = UIColor.init(red: 255/255, green: 254/255, blue: 132/255, alpha: 1.0)
    var greenColor = UIColor.init(red: 70/255, green: 254/255, blue: 208/255, alpha: 1.0)
    var purpleColor = UIColor.init(red: 69/255, green: 83/255, blue: 225/255, alpha: 1.0)

    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        var setSampleActuals = defaults.value(forKeyPath: "initialized")
        
        if setSampleActuals == nil {
             actual = [65.0, 15.0, 25.0, 430.0, 15.0, 550.0]
            defaults.set(actual, forKey: "actual")
            defaults.set(true, forKey: "initialized")
        }
        
        else{
            actual = defaults.value(forKeyPath: "actual") as! [Double]
        }
            
        setChart(dataPoints: categories, values: actual)
            
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UIApplication.shared.statusBarStyle = .lightContent
        self.tabBarController?.tabBar.tintColor = purpleColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

        // Data
        let defaults = UserDefaults.standard
        categories = ["FOOD", "FUN", "CLOTHES", "UTILITIES", "GAS", "OVERALL"]
        
        let setSampleActuals = defaults.value(forKeyPath: "initialized")
        
        if setSampleActuals == nil {
             actual = [65.0, 15.0, 25.0, 430.0, 15.0, 550.0]
            defaults.set(actual, forKey: "actual")
            defaults.set(true, forKey: "initialized")
        }
    
        else{
            actual = defaults.value(forKeyPath: "actual") as! [Double]
        }
        

        
        
        // Customize x axis
        barChartView.xAxis.enabled = true
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: categories)
        barChartView.xAxis.labelTextColor = UIColor.white
        barChartView.xAxis.labelFont = UIFont(name: "Avenir-Black", size: 20.0)!
        barChartView.xAxis.axisLineColor = UIColor.clear
//        barChartView.xAxis.yOffset = -25
        barChartView.xAxis.labelRotationAngle = 90
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.drawGridLinesEnabled = false

        // Remove Gridlines and axis labels
//        barChartView.leftAxis.enabled = false
        barChartView.leftAxis.gridColor = UIColor.white
        barChartView.leftAxis.axisLineColor = UIColor.white

        barChartView.leftAxis.labelTextColor = UIColor.white
        barChartView.rightAxis.enabled = false
        barChartView.drawBordersEnabled = false
        barChartView.minOffset = 0
        barChartView.highlightPerTapEnabled = false
        barChartView.highlightPerDragEnabled = false


        // Remove legend
        barChartView.legend.enabled = false
        
        // Set Chart Description to nil (no descrip.)
        barChartView.chartDescription?.text = ""

        // Populate the Chart
        setChart(dataPoints: categories, values: actual)
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
        
        // User actual data
        var actual = values
        // User set limits for budgets

        var cap = [160.0, 50.0, 50.0, 615.0, 35.0, 975.0]
        
        
        for i in 0..<dataPoints.count {
            
            var difference = cap[i]-actual[i]
            if difference < 0 {
                actual[i] = cap[i]
            }
            let dataEntry = BarChartDataEntry(x: Double(i), yValues: [actual[i], abs(difference)])
            
            dataEntries.append(dataEntry)
            
            // Set Bar color for value
            barColors.append(setColor(value: difference))
            
            // Top of bar is "fillable"
            if difference < 0{
                barColors.append(darkRedColor)
            }
            else{
                barColors.append(UIColor.clear)
            }
            
            // Still need to handle over budget
        }
        
        // Populate Data into Chart
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Units Sold")
        chartDataSet.colors = barColors
        
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        // Fillable aesthetic (add a border) around entire bar
        chartDataSet.barBorderWidth = 2
        chartDataSet.barBorderColor = UIColor.white
        
        // Remove bar labels
        chartData.setDrawValues(false)
        
    }
    

    // Function to determine bar color
    func setColor(value: Double)-> UIColor{
        let diff = value
        if(diff < 10){
            return redColor
        }
        
        else if (diff < 30){
            return yellowColor
        }
        else{
            return greenColor
        }
    }
}

