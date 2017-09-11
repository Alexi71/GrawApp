//
//  ChartPressureViewController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 08.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit
import SFChartUI

class ChartPressureViewController: ChartBaseViewController,SFChartDataSource,SFChartDelegate {

    @IBOutlet weak var chartView: UIView!
    let axisY : SFLogarithmicAxis  = SFLogarithmicAxis()
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
        
        let horizontalConstraint = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: chartView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: chartView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: chartView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: chart, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: chartView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        let axisX :SFNumericalAxis = SFNumericalAxis()
        axisX.minimum = -90
        axisX.maximum = 50
        axisX.showMajorGridLines = true
        axisX.interval = 10
        axisX.isVisible = true
        axisX.title.text = "Temperature °C"
        chart.primaryAxis = axisX
        
        //Adding secondary axis to the chart.
        
        //axisY.interval = 200
        axisY.title.text = "Pressure mB"
        axisY.isVisible = true
        axisY.isInversed = true
        chart.secondaryAxis = axisY
        chart.title.text = "Pressure Profile"
        chart.legend.isVisible = true
        chart.legend.toggleSeriesVisibility = false
        getChartDataForPressure()
        chart.dataSource = self
        chart.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func chart(_ chart: SFChart!, formattedAxisLabelForLabel label: String!, forValue value: Any!, axis: SFAxis!) -> String! {
        if axis == axisY {
            var value :Int = Int(label)!
            value = value / 1000
            let newLabel = "\(value)km"
            return newLabel
        }
        
        return label
    }*/
    
    func numberOfSeries(in chart: SFChart!) -> Int {
        return 4
    }
    
    func chart(_ chart: SFChart!, seriesAt index: Int) -> SFSeries! {
        let series : SFLineSeries = SFLineSeries()
        series.enableAnimation = true
        let scatterSeries :SFScatterSeries = SFScatterSeries()
        scatterSeries.enableAnimation = true
        scatterSeries.visibleOnLegend = false
        scatterSeries.enableTooltip = true
        
        if index == 0 || index == 2 {
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
        else if index == 1 || index == 3 {
            /*let axis2 :SFNumericalAxis   = SFNumericalAxis()
            axis2.minimum = 0
            axis2.maximum = 100
            axis2.showMajorGridLines      = false
            axis2.isOpposedPosition         = true
            axis2.title.text              = "Number of Customers"
            axis2.interval                = 5
            axis2.isVisible = false*/
            
            if index == 1 {
                //series.xAxis = axis2
                series.label                = "Dewpoint"
                series.color = UIColor(red: 215/255, green: 76/255, blue: 1/255, alpha: 1.0)
            }
            else {
                //scatterSeries.xAxis = axis2
                scatterSeries.label = "Humidity"
                scatterSeries.color = UIColor(red: 215/255, green: 76/255, blue: 1/255, alpha: 1.0)
                return scatterSeries
            }
            
            
            return series
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
            return temperatureReducedData.count
        case 3:
            return humidityReducedData.count
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
            return temperatureReducedData[index]
        case 3:
            return humidityReducedData[index]
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
