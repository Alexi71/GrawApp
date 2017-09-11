//
//  InputDataController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 01.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import Foundation
import SwiftyJSON

class InpuDataController {
    
    var inputDataArray:[InputData] = []
    var jsonData :JSON?
    
    init(data:JSON) {
        jsonData = data
        createDataFromJson()
    }
    
    private func createDataFromJson() {
        if let data = jsonData {
            for i in 0...data.count-1 {
                let inputData:InputData = InputData()
                inputData.time = data[i]["Time"].double!
                inputData.pressure = data[i]["Pressure"].double!
                inputData.temperature = data[i]["Temperature"].double!
                inputData.humidity = data[i]["Humidity"].double!
                inputData.windSpeed = data[i]["WindSpeed"].double!
                inputData.windDirection = data[i]["WindDirection"].double!
                inputData.geopotential = data[i]["Geopotential"].double!
                inputData.altitude = data[i]["Altitude"].double!
                inputData.dewpoint = data[i]["DewPoint"].double!
                inputData.latitude = data[i]["Latitude"].double!
                inputData.longitude = data[i]["Longitude"].double!
                inputDataArray.append(inputData)
            }
        }
    }
}


