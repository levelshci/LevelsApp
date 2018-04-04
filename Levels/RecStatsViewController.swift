//
//  RecStatsViewController.swift
//  Levels
//
//  Created by Jonathan Pereyra on 4/3/18.
//  Copyright © 2018 Jonathan Pereyra. All rights reserved.
//
import UIKit
import Spring
import Charts


class RecStatsViewController: UIViewController {
    var categories: [String]!

    @IBOutlet weak var detailRec: SpringView!
    @IBOutlet weak var recOverview: SpringView!
    @IBAction func dismissView(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func showRecs(_ sender: Any) {
        recOverview.animation = "slideDown"
        detailRec.animation = "slideUp"
        recOverview.delay = 0
        detailRec.delay = 0
        recOverview.animateToNext {
            self.recOverview.isHidden = true
            self.detailRec.isHidden = false
            self.detailRec.animate()
            
        }
    }
    
    @IBAction func swipeToDismissView(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var barChartView: BarChartView!
    var darkRedColor = UIColor.init(red: 192/255, green: 53/255, blue: 202/255, alpha: 1.0)
    var redColor = UIColor.init(red: 234/255, green: 65/255, blue: 247/255, alpha: 1.0)
    var yellowColor = UIColor.init(red: 255/255, green: 254/255, blue: 132/255, alpha: 1.0)
    var greenColor = UIColor.init(red: 70/255, green: 254/255, blue: 208/255, alpha: 1.0)
    var purpleColor = UIColor.init(red: 69/255, green: 83/255, blue: 225/255, alpha: 1.0)
    
    @IBOutlet weak var goodBarChart: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UIApplication.shared.statusBarStyle = .default
        
        categories = ["TEST"]

        let actual = [60.0, 15.0, 5.0]
        let goodProjection = [60.0, 15.0, 12.0]

       setUpBarChartAppearance(barChartView: barChartView)
       setUpBarChartAppearance(barChartView: goodBarChart)

        
        // Populate the Chart
        setChart(chart: barChartView, dataPoints: categories, values: actual)
        setChart1(chart: goodBarChart, dataPoints: categories, values: goodProjection)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func setChart(chart: BarChartView, dataPoints: [String], values: [Double]) {
        // Array for Bar Colors
        var barColors = [UIColor]()
        
        // Store Data
        var dataEntries: [BarChartDataEntry] = []
        
        // User actual data
        var actual = values
        // User set limits for budgets
        

        let dataEntry = BarChartDataEntry(x: 0, yValues: [actual[0], actual[1], actual[2]])
    
        dataEntries.append(dataEntry)
    
        // Set Bar color for value
        barColors.append(greenColor)
        barColors.append(yellowColor)
        barColors.append(redColor)
        
        
        // Populate Data into Chart
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Units Sold")
        chartDataSet.colors = barColors
        
        let chartData = BarChartData(dataSet: chartDataSet)
        chart.data = chartData
        
        // Fillable aesthetic (add a border) around entire bar
        chartDataSet.barBorderWidth = 2
        chartDataSet.barBorderColor = UIColor.black
        
        // Remove bar labels
        chartData.setDrawValues(false)
        
    }
    
    func setChart1(chart: BarChartView, dataPoints: [String], values: [Double]) {
        // Array for Bar Colors
        var barColors = [UIColor]()
        
        // Store Data
        var dataEntries: [BarChartDataEntry] = []
        
        // User actual data
        var actual = values
        // User set limits for budgets
        
        
        let dataEntry = BarChartDataEntry(x: 0, yValues: [actual[0], actual[1], actual[2]])
        
        dataEntries.append(dataEntry)
        
        // Set Bar color for value
        barColors.append(greenColor)
        barColors.append(yellowColor)
        barColors.append(UIColor.clear)
        
        
        // Populate Data into Chart
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Units Sold")
        chartDataSet.colors = barColors
        
        let chartData = BarChartData(dataSet: chartDataSet)
        chart.data = chartData
        
        // Fillable aesthetic (add a border) around entire bar
        chartDataSet.barBorderWidth = 2
        chartDataSet.barBorderColor = UIColor.black
        
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
    
    func setUpBarChartAppearance(barChartView: BarChartView){
        // Customize x axis
        barChartView.xAxis.enabled = true
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: categories)
        barChartView.xAxis.labelTextColor = UIColor.black
        barChartView.xAxis.labelFont = UIFont(name: "Avenir-Black", size: 20.0)!
        barChartView.xAxis.axisLineColor = UIColor.clear
        
        barChartView.xAxis.yOffset = -25
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.drawGridLinesEnabled = false
        
        // Remove Gridlines and axis labels
        //        barChartView.leftAxis.enabled = false
        //        barChartView.leftAxis.gridColor = UIColor.white
        //        barChartView.leftAxis.axisLineColor = UIColor.white
        
        barChartView.leftAxis.labelTextColor = UIColor.black
        barChartView.rightAxis.enabled = false
        barChartView.drawBordersEnabled = false
        barChartView.minOffset = 0
        barChartView.highlightPerTapEnabled = false
        barChartView.highlightPerDragEnabled = false
        barChartView.pinchZoomEnabled = true
        barChartView.doubleTapToZoomEnabled = false
        
        
        // Remove legend
        barChartView.legend.enabled = false
        
        // Set Chart Description to nil (no descrip.)
        barChartView.chartDescription?.text = ""
        
    }
}
