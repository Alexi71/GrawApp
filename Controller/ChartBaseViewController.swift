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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
