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
    
    init (data : [Data]) {
        createDataFromCoreData(items: data)
    }
    
    private func createDataFromCoreData(items: [Data]) {
        let sortedItems = items.sorted{$0.time < $1.time}
        for item in sortedItems {
            let inputData:InputData = InputData()
            inputData.time = item.time
            inputData.pressure = item.pressure
            inputData.temperature = item.temperature
            inputData.humidity = item.humidity
            inputData.windSpeed = item.windspeed
            inputData.windDirection = item.winddirection
            inputData.geopotential = item.geopotential
            inputData.altitude = item.altitude
            inputData.dewpoint = item.dewpoint
            inputData.latitude = item.latitude
            inputData.longitude = item.longitude
            inputDataArray.append(inputData)
        }
        
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


