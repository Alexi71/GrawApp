//
//  StationViewController.swift
//  
//
//  Created by Alexander Kotik on 24.08.17.
//

import UIKit
import FirebaseDatabase
import MapKit
import Alamofire
import SwiftyJSON


class StationViewController:
UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDelegate,
UITableViewDataSource{

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    var manager = CLLocationManager()
    var activeStation : Station?
    var flights : [FlightData] = []
    var currentCoordinates : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var zoom = 1000
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    let weatherDataModel = WeatherDataModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
        }
        else {
              manager.requestWhenInUseAuthorization();
        }
        self.tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
       
        initializeDatabase()
        if let station = activeStation {
            self.title = station.name + ", " + station.id
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Location
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            manager.stopUpdatingLocation()
            if let center = manager.location?.coordinate {
                let region = MKCoordinateRegionMakeWithDistance(center, 1000, 1000)
                mapView.setRegion(region, animated: false)
            }
        }
    }
    
    //MARK: - Database
    func initializeDatabase()  {
        if let key = activeStation?.key {
      Database.database().reference().child("station").child(key).child("flights").observe(.childAdded) { (snapshot) in
        
                if let flights = snapshot.value as? NSDictionary {
                    let item :FlightData = FlightData()
                    if let date = flights["Date"] as?  String {
                        item.date = date
                    }
                    if let time = flights["Time"] as?  String {
                        item.time = time
                    }
                    
                    if let fileName = flights["FileName"] as?  String {
                        item.fileName = fileName
                    }
                    
                    if let url = flights["Url"] as?  String {
                        item.url = url
                    }
                    self.flights.append(item)
                    
                    self.tableView.reloadData()
                    self.addAnnotationOfStation()
                }
        
            }
        }
        
    }
    
    func addAnnotationOfStation() {
        if let item = activeStation {
            let anno = MKPointAnnotation()
            if let lat = Double(item.latitude) {
                anno.coordinate.latitude = lat
            }
            if let long = Double(item.longitude) {
                anno.coordinate.longitude = long
            }
            mapView.addAnnotation(anno)
            let region = MKCoordinateRegionMakeWithDistance(anno.coordinate, 1000, 1000)
            mapView.setRegion(region, animated: false)
            currentCoordinates = anno.coordinate
            let longitude = String(currentCoordinates.longitude)
            let latitude = String(currentCoordinates.latitude)
            let prams :[String:String] = ["lat":latitude,"lon":longitude,"appid":APP_ID]
            getWeatherData(url:WEATHER_URL, parameter:prams)
        }
    }
    
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = flights[indexPath.row].date + " " + flights[indexPath.row].time
        UITableViewCell.appearance().textLabel?.textColor = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
        cell.textLabel?.backgroundColor = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
        UITableViewCell.appearance().backgroundColor = UIColor.clear
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let item = stationItems[indexPath.row]
        let anno = MKPointAnnotation()
        if let lat = Double(item.latitude) {
            anno.coordinate.latitude = lat
        }
        if let long = Double(item.longitude) {
            anno.coordinate.longitude = long
        }
        mapView.addAnnotation(anno)
        let region = MKCoordinateRegionMakeWithDistance(anno.coordinate, 1000, 1000)
        mapView.setRegion(region, animated: false) */
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("tapped")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url:String, parameter:[String:String]){
        Alamofire.request(url, method: .get, parameters: parameter).responseJSON{
            response in
            if response.result.isSuccess{
                print ("Success. Got the weather data")
                let weatherJSON:JSON = JSON(response.result.value!)
                print (weatherJSON)
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print ("Error \(response.result.error ?? "Connection issue" as! Error)")
                self.cityLabel.text = "Connection issue"
            }
        }
        
    }
    
    
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateWeatherData method here:
    func updateWeatherData (json:JSON){
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            updataUIWithWeatherData()
        }
        else
        {
            cityLabel.text = "Weather data are not available"
        }
    }
    
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    func updataUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }

}
