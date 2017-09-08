//
//  ChartBaseViewController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 06.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit
import SFChartUI
class ChartBaseViewController: UIViewController {

    var dataItems:InpuDataController?
    var index :Int = 0
    
    var temperatureData : [SFChartDataPoint] = []
    var humidityData :[SFChartDataPoint] = []
    var pressureData : [SFChartDataPoint] = []
    var windData :[SFChartDataPoint] = []
    
    var temperatureReducedData : [SFChartDataPoint] = []
    var humidityReducedData :[SFChartDataPoint] = []
    var pressureReducedData : [SFChartDataPoint] = []
    var windReducedData :[SFChartDataPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func getChartData() {
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
            
            temperatureReducedData = temperatureData.filter({ (item) -> Bool in
                if let xValue = item.xValue as? Int {
                    if xValue % 600 == 0 {
                        return true
                    }
                }
                return false
            })
            
            pressureReducedData = pressureData.filter({ (item) -> Bool in
                if let xValue = item.xValue as? Int {
                    if xValue % 600 == 0 {
                        return true
                    }
                }
                return false
            })
            
            humidityReducedData = humidityData.filter({ (item) -> Bool in
                if let xValue = item.xValue as? Int {
                    if xValue % 600 == 0 {
                        return true
                    }
                }
                return false
            })
            
            windReducedData = windData.filter({ (item) -> Bool in
                if let xValue = item.xValue as? Int {
                    if xValue % 600 == 0 {
                        return true
                    }
                }
                
                return false
                
            })
        }
    }
    
    internal func getChartDataForAltitude() {
        //self.view.addSubview(chart)
        if let dataArray = dataItems {
            for item in dataArray.inputDataArray {
                temperatureData.append(SFChartDataPoint(xValue: item.temperature, andYValue: item.geopotential))
            }
            
            for item in dataArray.inputDataArray {
                humidityData.append(SFChartDataPoint(xValue: item.humidity, andYValue: item.geopotential))
            }
            
            for item in dataArray.inputDataArray {
                pressureData.append(SFChartDataPoint(xValue: item.pressure, andYValue: item.geopotential))
            }
            
            for item in dataArray.inputDataArray {
                windData.append(SFChartDataPoint(xValue: item.windSpeed, andYValue: item.geopotential))
            }
            var levelValue :Int = 0
            temperatureReducedData = temperatureData.filter({ (item) -> Bool in
                if let xValue = item.yValue as? Int {
                    let roundedValue = Int(round(Double(xValue / 1000)) * 1000)
                    if roundedValue % 5000 == 0 && levelValue != roundedValue {
                        print (levelValue)
                        levelValue = roundedValue
                        return true
                    }
                }
                return false
            })
            
            pressureReducedData = pressureData.filter({ (item) -> Bool in
                if let xValue = item.yValue as? Int {
                    let roundedValue = Int(round(Double(xValue / 1000)) * 1000)
                    if roundedValue % 5000 == 0 && levelValue != roundedValue {
                        print (levelValue)
                        levelValue = roundedValue
                        return true
                    }
                }
                
                return false
            })
            
            humidityReducedData = humidityData.filter({ (item) -> Bool in
                if let xValue = item.yValue as? Int {
                    let roundedValue = Int(round(Double(xValue / 1000)) * 1000)
                    if roundedValue % 5000 == 0 && levelValue != roundedValue {
                        print (levelValue)
                        levelValue = roundedValue
                        return true
                    }
                }
                return false
            })
            
            windReducedData = windData.filter({ (item) -> Bool in
                if let xValue = item.yValue as? Int {
                    let roundedValue = Int(round(Double(xValue / 1000)) * 1000)
                    if roundedValue % 5000 == 0 && levelValue != roundedValue {
                        print (levelValue)
                        levelValue = roundedValue
                        return true
                    }
                }
                
                return false
                
            })
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
