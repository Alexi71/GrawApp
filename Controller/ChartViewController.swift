//
//  ChartViewController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 01.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit
import SFChartUI

class ChartViewController: ChartBaseViewController,SFChartDataSource,SFChartDelegate {

    @IBOutlet weak var chartView: UIView!
    //var dataItems:InpuDataController?
    
    let axis1 : SFNumericalAxis  = SFNumericalAxis()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //init chart.....
        let chart :SFChart = SFChart()
        let zoomPan : SFChartZoomPanBehavior = SFChartZoomPanBehavior ()
        zoomPan.isEnableSelectionZooming  = true
        chart.addBehavior(zoomPan)
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
        
        
        axis1.showMajorGridLines = true
        axis1.interval = 600
        axis1.title.text = "Minutes"
        chart.primaryAxis = axis1
        
        //Adding secondary axis to the chart.
        
        let axis2 :SFNumericalAxis   = SFNumericalAxis()
        axis2.title.text = "Temperature"
        axis2.isVisible = true
        chart.secondaryAxis = axis2
        chart.title.text = "Time Profile"
        chart.legend.isVisible = true
        chart.legend.toggleSeriesVisibility = true
        getChartData()
      
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
        series.enableAnimation = true
        let scatterSeries :SFScatterSeries = SFScatterSeries()
        scatterSeries.enableAnimation = true
        scatterSeries.visibleOnLegend = false
        scatterSeries.enableTooltip = true
        
        if index == 0 || index == 5 {
            if index == 0 {
                series.label = "Temperature"
                series.color = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
                return series
            }
            else {
                scatterSeries.label = "Temperature"
                scatterSeries.color = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
                return scatterSeries
            }
            
        }
        else if index == 1 || index == 6 {
            let axis2 :SFNumericalAxis   = SFNumericalAxis()
            axis2.minimum = 0
            axis2.maximum = 100
            axis2.showMajorGridLines      = false
            axis2.isOpposedPosition         = true
            axis2.title.text              = "Number of Customers"
            axis2.interval                = 5
            axis2.isVisible = false
            
            if index == 1 {
                series.yAxis = axis2
                series.label                = "Humidity"
                series.color = UIColor(red: 215/255, green: 76/255, blue: 1/255, alpha: 1.0)
            }
            else {
                scatterSeries.yAxis = axis2
                scatterSeries.label = "Humidity"
                scatterSeries.color = UIColor(red: 215/255, green: 76/255, blue: 1/255, alpha: 1.0)
                return scatterSeries
            }
           
            
            return series
        }
        else if index == 2 || index == 4 {
            let axis2 :SFLogarithmicAxis   = SFLogarithmicAxis()
            axis2.minimum = 0
            axis2.maximum = 1100
            axis2.showMajorGridLines      = false
            axis2.isOpposedPosition         = true
            axis2.isVisible = false
            axis2.interval                = 100
            
            if index == 2 {
                series.yAxis = axis2
                series.label                = "Pressure"
                series.color = UIColor(red: 166/255, green: 2/255, blue: 2/255, alpha: 1.0)
                //series.enableTooltip = true
                return series
            }
            else {
                scatterSeries.yAxis = axis2
                scatterSeries.color = UIColor(red: 166/255, green: 2/255, blue: 2/255, alpha: 1.0)
                scatterSeries.label = "Pressure"
                /*scatterSeries.dataMarker.showLabel = true
                scatterSeries.dataMarker.showMarker = true
                scatterSeries.dataMarker.labelStyle.color = UIColor.blue
                scatterSeries.dataMarker.labelStyle.borderColor = UIColor.red
                scatterSeries.dataMarker.labelStyle.borderWidth     = 2
                scatterSeries.dataMarker.labelStyle.backgroundColor = UIColor.cyan
                scatterSeries.dataMarker.labelStyle.angle = 315
                scatterSeries.dataMarker.labelStyle.margin = UIEdgeInsetsMake(5, 5, 5, 5)
                scatterSeries.dataMarker.labelStyle.font = UIFont.italicSystemFont(ofSize: 18) */
                return scatterSeries
            }
            
        }
        else if index == 3 || index == 7 {
            let axis2 :SFNumericalAxis   = SFNumericalAxis()
            axis2.minimum = 0
            axis2.maximum = 100
            axis2.showMajorGridLines = false
            axis2.isOpposedPosition = true
            axis2.interval = 10
            axis2.isVisible = false
            if index == 3 {
                series.yAxis = axis2
                series.label = "Wind"
                series.color = UIColor(red: 4/255, green: 115/255, blue: 135/255, alpha: 1.0)
                series.enableAnimation = true
                return series
            }
            else {
                scatterSeries.label = "Wind"
                scatterSeries.yAxis = axis2
                scatterSeries.color = UIColor(red: 4/255, green: 115/255, blue: 135/255, alpha: 1.0)
                return scatterSeries
            }
           
        }
       
        
        else {
            return series
        }
    }
    
    func numberOfSeries(in chart: SFChart!) -> Int {
        return 8
    }
    func chart(_ chart: SFChart!, numberOfDataPointsForSeriesAt index: Int) -> Int
    {
        switch index {
        case 0:
            return temperatureData.count
        case 1:
            return humidityData.count
        case 2:
            return pressureData.count
        case 3:
            return windData.count
        case 4:
            return pressureReducedData.count
        case 5:
            return temperatureReducedData.count
        case 6:
            return humidityReducedData.count
        case 7:
            return windReducedData.count
        default:
            return 0
        }
        
    }
    
    func chart(_ chart: SFChart!, dataPointAt index: Int, forSeriesAt seriesIndex: Int) -> SFChartDataPoint! {
        
        switch seriesIndex {
        case 0:
            return temperatureData[index]
        case 1:
            return humidityData[index]
        case 2:
            return pressureData[index]
        case 3:
            return windData[index]
        case 4:
            return pressureReducedData[index]
        case 5:
            return temperatureReducedData[index]
        case 6:
            return humidityReducedData[index]
        case 7:
            return windReducedData[index]
        default:
            return SFChartDataPoint()
        }
        
    }
    
    
    
    func chart(_ chart: SFChart!, willShow tooltipView: SFChartTooltip!) {
        if let label = tooltipView.series.label {
            guard let point = tooltipView.dataPoint else {
                return
            }
            guard let seconds = point.xValue as? Int else {
                return
            }
            
            guard let value = point.yValue as? Double else {
                return
            }
            let minutes = seconds / 60
            
            switch label {
                
            case "Temperature":
                let text = String(format: "%.1f °C %d min", value,minutes)
                tooltipView.text = text
                return
            case "Pressure":
                let text = String(format: "%.1f mB %d min", value,minutes)
                tooltipView.text = text
                return
            case "Humidity":
                let text = String(format: "%d %% %d min", value,minutes)
                tooltipView.text = text
                return
            case "Wind":
                let text = String(format: "%.1f m/s %d min", value,minutes)
                tooltipView.text = text
                return
                
            default:
                // do nothing
                print("default")
            }
            
            
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
