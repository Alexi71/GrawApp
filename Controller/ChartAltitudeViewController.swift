//
//  ChartAltitudeViewController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 06.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit
import SFChartUI

class ChartAltitudeViewController: ChartBaseViewController,SFChartDataSource,SFChartDelegate  {

   
    @IBOutlet weak var ChartView: UIView!
    let axisY : SFNumericalAxis  = SFNumericalAxis()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chart :SFChart = SFChart()
        let zoomPan : SFChartZoomPanBehavior = SFChartZoomPanBehavior ()
        zoomPan.isEnableSelectionZooming  = true
        chart.addBehavior(zoomPan)
        let sampleFrame :CGRect = CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.origin.y, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        chart.frame = sampleFrame
        
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(chart)

        let horizontalConstraint = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: ChartView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: ChartView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: ChartView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: ChartView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        let axisX :SFNumericalAxis = SFNumericalAxis()
        axisX.minimum = -90
        axisX.maximum = 50
        axisX.showMajorGridLines = true
        axisX.interval = 10
        axisX.isVisible = false
        chart.primaryAxis = axisX
        
        //Adding secondary axis to the chart.
        
       
        axisY.title.text = "Altitude"
        axisY.isVisible = true
        chart.secondaryAxis = axisY
        chart.title.text = "Altitude Profile"
        chart.legend.isVisible = true
        chart.legend.toggleSeriesVisibility = false
        getChartDataForAltitude()
        chart.dataSource = self
        chart.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func chart(_ chart: SFChart!, formattedAxisLabelForLabel label: String!, forValue value: Any!, axis: SFAxis!) -> String! {
        if axis == axisY {
            var value :Int = Int(label)!
            value = value / 1000
            let newLabel = "\(value)km"
            return newLabel
        }
        
        return label
    }
    
    func numberOfSeries(in chart: SFChart!) -> Int {
        return 8
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
                series.xAxis = axis2
                series.label                = "Humidity"
                series.color = UIColor(red: 215/255, green: 76/255, blue: 1/255, alpha: 1.0)
            }
            else {
                scatterSeries.xAxis = axis2
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
                series.xAxis = axis2
                series.label                = "Pressure"
                series.color = UIColor(red: 166/255, green: 2/255, blue: 2/255, alpha: 1.0)
                //series.enableTooltip = true
                return series
            }
            else {
                scatterSeries.xAxis = axis2
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
                series.xAxis = axis2
                series.label = "Wind"
                series.color = UIColor(red: 4/255, green: 115/255, blue: 135/255, alpha: 1.0)
                series.enableAnimation = true
                return series
            }
            else {
                scatterSeries.label = "Wind"
                scatterSeries.xAxis = axis2
                scatterSeries.color = UIColor(red: 4/255, green: 115/255, blue: 135/255, alpha: 1.0)
                return scatterSeries
            }
            
        }
            
            
        else {
            return series
        }
    }
    
    func chart(_ chart: SFChart!, numberOfDataPointsForSeriesAt index: Int) -> Int {
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

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
