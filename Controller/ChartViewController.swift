//
//  ChartViewController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 01.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit
import SFChartUI

class ChartViewController: UIViewController,SFChartDataSource {

    @IBOutlet weak var chartView: UIView!
    var dataItems:InpuDataController?
    var data : [SFChartDataPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.title = "Back"
        
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
        
        
        let axis1 : SFCategoryAxis  = SFCategoryAxis();
        axis1.title.text            = "Month";
        chart.primaryAxis           = axis1;
        
        //Adding secondary axis to the chart.
        
        let axis2 :SFNumericalAxis   = SFNumericalAxis();
        axis2.title.text            = "Temperature";
        chart.secondaryAxis         = axis2;
        chart.title.text = "Weather Analysis"
        
        //self.view.addSubview(chart)
        data.append(SFChartDataPoint( xValue: "Jan", andYValue: 42));
        data.append(SFChartDataPoint( xValue: "Feb", andYValue: 44));
        data.append(SFChartDataPoint( xValue: "Mar", andYValue: 53));
        data.append(SFChartDataPoint( xValue: "Apr", andYValue: 64));
        data.append(SFChartDataPoint( xValue: "May", andYValue: 75));
        data.append(SFChartDataPoint( xValue: "Jun", andYValue: 83));
        data.append(SFChartDataPoint( xValue: "Jul", andYValue: 87));
        data.append(SFChartDataPoint( xValue: "Aug", andYValue: 84));
        data.append(SFChartDataPoint( xValue: "Sep", andYValue: 78));
        data.append(SFChartDataPoint( xValue: "Oct", andYValue: 67));
        data.append(SFChartDataPoint( xValue: "Nov", andYValue: 55));
        data.append(SFChartDataPoint( xValue: "Dec", andYValue: 45))
        chart.dataSource = self
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func chart(_ chart: SFChart!, seriesAt index: Int) -> SFSeries! {
        let series : SFSplineSeries = SFSplineSeries();
        series.label                = "Low";
        return series;
    }
    
    func numberOfSeries(in chart: SFChart!) -> Int {
        return 1
    }
    func chart(_ chart: SFChart!, numberOfDataPointsForSeriesAt index: Int) -> Int
    {
        return data.count;
    }
    
    func chart(_ chart: SFChart!, dataPointAt index: Int, forSeriesAt seriesIndex: Int) -> SFChartDataPoint! {
        return data[index]
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
