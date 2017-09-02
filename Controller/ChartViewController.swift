//
//  ChartViewController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 01.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit
import SFChartUI

class ChartViewController: UIViewController,SFChartDataSource,SFChartDelegate {

    @IBOutlet weak var chartView: UIView!
    var dataItems:InpuDataController?
    var temperatureData : [SFChartDataPoint] = []
    var humidityData :[SFChartDataPoint] = []
    var pressureData : [SFChartDataPoint] = []
    var windData :[SFChartDataPoint] = []
    let axis1 : SFNumericalAxis  = SFNumericalAxis()
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        self.navigationItem.backBarButtonItem = backItem
        
        //init chart.....
        let chart :SFChart = SFChart()
        print ("x: \(chartView.frame.origin.x) y: \(chartView.frame.origin.y) width: \(chartView.frame.width) height: \(chartView.frame.height)" )
        let sampleFrame :CGRect = CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.origin.y, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        chart.frame = sampleFrame
        
        chart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chart)
        /*
        let horizontalConstraint = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view.safeAreaLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view.safeAreaLayoutGuide, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view.safeAreaLayoutGuide, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: view.safeAreaLayoutGuide, attribute: NSLayoutAttribute.height, multiplier: 0.5, constant: 0)*/
        
        let horizontalConstraint = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: chartView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: chartView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: chartView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: chartView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        
        //let axis1 : SFNumericalAxis  = SFNumericalAxis()
        axis1.interval = 600
        axis1.title.text            = "Minutes"
        chart.primaryAxis           = axis1;
        
        //Adding secondary axis to the chart.
        
        let axis2 :SFNumericalAxis   = SFNumericalAxis();
        axis2.title.text            = "Temperature";
        chart.secondaryAxis         = axis2;
        chart.title.text = "Weather Analysis"
        chart.legend.isVisible                    = true;
        chart.legend.toggleSeriesVisibility     = true;
        //self.view.addSubview(chart)
        if let dataArray = dataItems {
            for item in dataArray.inputDataArray {
                temperatureData.append(SFChartDataPoint(xValue: item.time, andYValue: item.temperature))
            }
            
            for item in dataArray.inputDataArray {
                humidityData.append(SFChartDataPoint(xValue: item.time, andYValue: item.humidity))
            }
            
            for item in dataArray.inputDataArray {
                pressureData.append(SFChartDataPoint(xValue: item.time, andYValue: item.pressure))
            }
            
            for item in dataArray.inputDataArray {
                windData.append(SFChartDataPoint(xValue: item.time, andYValue: item.windSpeed))
            }
        }
      
        chart.dataSource = self
        chart.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func chart(_ chart: SFChart!, formattedAxisLabelForLabel label: String!, forValue value: Any!, axis: SFAxis!) -> String! {
        if axis == axis1 {
            var value :Int = Int(label)!
            value = value / 60
            let newLabel = "\(value)"
            return newLabel
        }
        
        return label
    }
    func chart(_ chart: SFChart!, seriesAt index: Int) -> SFSeries! {
        let series : SFLineSeries = SFLineSeries()
        if index == 0 {
            /*let axis2 :SFNumericalAxis   = SFNumericalAxis()
            axis2.minimum = 40
            axis2.maximum = -90
            axis2.showMajorGridLines      = false;
            axis2.isOpposedPosition         = true;
            axis2.title.text              = "temperature";
            axis2.interval                = 10;
            series.yAxis = axis2 */
            series.label                = "Temperature"
            return series
        }
        else {
            let axis2 :SFNumericalAxis   = SFNumericalAxis()
            axis2.minimum = 0
            axis2.maximum = 100
            axis2.showMajorGridLines      = false;
            axis2.isOpposedPosition         = true;
            axis2.title.text              = "Number of Customers";
            axis2.minimum                 = 0;
            axis2.maximum                 = 100;
            axis2.interval                = 5;
            //let series : SFLineSeries = SFLineSeries()
            series.yAxis = axis2
            series.label                = "Humidity"
            series.color = UIColor.green
            
            return series
        }
    }
    
    func numberOfSeries(in chart: SFChart!) -> Int {
        return 2
    }
    func chart(_ chart: SFChart!, numberOfDataPointsForSeriesAt index: Int) -> Int
    {
        if index == 0 {
            return temperatureData.count
        }
        else {
            return humidityData.count
        }
    }
    
    func chart(_ chart: SFChart!, dataPointAt index: Int, forSeriesAt seriesIndex: Int) -> SFChartDataPoint! {
        if seriesIndex == 0 {
            return temperatureData[index]
        }
        else {
            return humidityData[index]
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
