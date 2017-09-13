//
//  RawViewController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 13.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RawViewController: UIViewController {

    @IBOutlet weak var pressureValueLabel: UILabel!
    @IBOutlet weak var temperatureValueLabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    @IBOutlet weak var altitudeValueLabel: UILabel!
    @IBOutlet weak var windSpeedValueLabel: UILabel!
    @IBOutlet weak var windDirectionValueLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        initDatabase()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initDatabase() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let flightData = appDelegate.flightData
        let activeStation = appDelegate.activeStation
        
        guard let stationKey = activeStation?.key, let flightKey = flightData?.key else {
            return
        }
        
        
    Database.database().reference().child("station").child(stationKey).child("flights").child(flightKey).child("rawdata").observe(.childAdded) { (snapshot) in
        
            if let flightdata = snapshot.value as? NSDictionary {
                
                if let pressure = flightdata["Pressure"] as? NSNumber {
                    let nf = NumberFormatter()
                    nf.numberStyle = .decimal
                    nf.minimumFractionDigits = 0
                    nf.maximumFractionDigits = 1
                    self.pressureValueLabel.text = nf.string(from: pressure)! + "mB"
                }
                
                if let temperature = flightdata["Temperature"] as? NSNumber {
                    let nf = NumberFormatter()
                    nf.numberStyle = .decimal
                    nf.minimumFractionDigits = 0
                    nf.maximumFractionDigits = 1
                    self.temperatureValueLabel.text = nf.string(from: temperature)! + "°C"
                }
                
                if let humidity = flightdata["Humidity"] as? NSNumber {
                    let nf = NumberFormatter()
                    nf.numberStyle = .decimal
                    nf.minimumFractionDigits = 0
                    nf.maximumFractionDigits = 0
                    self.humidityValueLabel.text = nf.string(from: humidity)! + "%"
                }
                
                
                if let altitude = flightdata["Altitude"] as? NSNumber {
                    let nf = NumberFormatter()
                    nf.numberStyle = .decimal
                    nf.minimumFractionDigits = 0
                    nf.maximumFractionDigits = 0
                    self.altitudeValueLabel.text = nf.string(from: altitude)! + "m"
                }
                
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
