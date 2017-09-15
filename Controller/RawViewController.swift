//
//  RawViewController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 13.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit
import FirebaseDatabase
import  MapKit
class RawViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pressureValueLabel: UILabel!
    @IBOutlet weak var temperatureValueLabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    @IBOutlet weak var altitudeValueLabel: UILabel!
    @IBOutlet weak var windSpeedValueLabel: UILabel!
    @IBOutlet weak var windDirectionValueLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        let locationManager = CLLocationManager()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            //addAnnotationOfStation()
            locationManager.startUpdatingLocation()
            //addPath()
        }
        else {
            locationManager.requestWhenInUseAuthorization();
        }
        initDatabase()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            manager.stopUpdatingLocation()
            if let center = manager.location?.coordinate {
                let region = MKCoordinateRegionMakeWithDistance(center, 5000, 5000)
                mapView.setRegion(region, animated: false)
            }
        }
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
                
                if let timeStamp = flightdata["TimeStamp"] as? String {
                    /*let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                    let myDate  = formatter.date(from: timeStamp)*/
                    
                    self.timeLabel.text = "last updated: " + timeStamp
                }
                
                if let latitude = flightdata["Latitude"] as? Double {
                    if let longitude = flightdata["Longitude"] as? Double {
                        self.addAnnotation(latitude: latitude, longitude: longitude)
                    }
                }
                
            }
        }
    }
    
    
    func addAnnotation(latitude : Double, longitude :Double) {
        self.mapView.annotations.forEach {
            if !($0 is MKUserLocation) {
                self.mapView.removeAnnotation($0)
            }
        }
        let anno = MKPointAnnotation()
        anno.coordinate.latitude = latitude
        anno.coordinate.longitude = longitude
        mapView.addAnnotation(anno)
        let region = MKCoordinateRegionMakeWithDistance(anno.coordinate, 5000, 5000)
        mapView.setRegion(region, animated: false)
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
