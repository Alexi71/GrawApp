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
import SWRevealViewController
import SFBusyIndicatorUI



class StationViewController:
UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDelegate,
UITableViewDataSource{

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var weatherView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    var manager = CLLocationManager()
    var activeStation : Station?
    var flights : [FlightData] = []
    var currentCoordinates : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var zoom = 1000
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    let weatherDataModel = WeatherDataModel()
    var busyIndicator:SFBusyIndicator=SFBusyIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        busyIndicator.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        busyIndicator.isOpaque = true
        busyIndicator.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        busyIndicator.duration = 1
        busyIndicator.viewBoxWidth = 80
        busyIndicator.viewBoxHeight = 80
        busyIndicator.animationType = SFBusyIndicatorAnimationTypeSlicedCircle
        busyIndicator.foreground =  UIColor.orange
        busyIndicator.isHidden = true
        self.view.addSubview(busyIndicator)
        manager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //mapView.showsUserLocation = true
            //addAnnotationOfStation()
            //manager.startUpdatingLocation()
        }
        else {
              manager.requestWhenInUseAuthorization();
        }
        self.tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
        weatherView.backgroundColor =  UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
        mainView.backgroundColor =  UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
        initializeDatabase()
        if let station = activeStation {
            self.title = station.name + ", " + station.id
        }
        
        // Do any additional setup after loading the view.
    }
   
    
    /*func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }*/
    
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
    @IBAction func hamburgerTapped(_ sender: UIBarButtonItem) {
        self.revealViewController().revealToggle(sender)
        //SWRevealViewController 
    }
    
    //MARK: - Database
    func initializeDatabase()  {
        if let key = activeStation?.key {
      Database.database().reference().child("station").child(key).child("flights").observe(.childAdded) { (snapshot) in
                let item :FlightData = FlightData()
                item.key = snapshot.key
                if let flights = snapshot.value as? NSDictionary {
                    
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
                    
                    if let url100 = flights["Url100"] as? String {
                        item.url100 = url100
                    }
                    
                    if let urlEnd = flights["UrlEnd"] as? String {
                        item.urlEnd = urlEnd
                    }
                    self.flights.append(item)
                    
                    self.tableView.reloadData()
                    
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
        cell.backgroundColor = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = flights[indexPath.row].date + " " + flights[indexPath.row].time
      
        /*UITableViewCell.appearance().textLabel?.textColor = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
        cell.textLabel?.backgroundColor = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
        UITableViewCell.appearance().backgroundColor = UIColor.clear*/
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let flight = flights[indexPath.row]
        busyIndicator.isHidden = false
        var flightFound = CoreDataHelper.isFlightStored(key: flight.key)
        
        if flightFound {
            if let data = CoreDataHelper.getFlightData(key: flight.key) {
                for item in data {
                    let dataSet = item.flightHasData?.allObjects as! [Data]
                    print (dataSet.count)
                    let inputData:InpuDataController = InpuDataController(data: dataSet)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.flightData = flight
                    self.busyIndicator.isHidden = true
                    self.performSegue(withIdentifier: "gotoChartView", sender: inputData)
                    return
                }
            }
            else {
                flightFound = false
            }
            
        }
        
        Alamofire.request(flight.url, method: .get, parameters: nil).responseJSON{
            response in
            self.busyIndicator.isHidden = true
            if response.result.isSuccess{
                print ("Success. Got the weather data")
                let weatherJSON:JSON = JSON(response.result.value!)
               // let data:NSData = weatherJSON.rawValue as! NSData
                //let json:JSON = JSON(data)
                //print (weatherJSON)
                //print (weatherJSON[1]["Time"].int!)
                //print (weatherJSON.count)
                //print ("Try to perform segue")
                let inputData:InpuDataController = InpuDataController(data: weatherJSON)
                print(inputData.inputDataArray.count)
                //add flight to core data.... speed up offline flights....
                if !flightFound {
                    CoreDataHelper.insertFlightData(flight: flight, dataArray: inputData.inputDataArray)
                }
                //save current flight
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.flightData = flight
                self.performSegue(withIdentifier: "gotoChartView", sender: inputData)
                /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let nc = storyboard.instantiateViewController(withIdentifier: "tabViewData") as! UITabBarController
                //let vc = nc. as! AddStationTableViewController
                //vc.activeStation = self.activeStation
                
                let rvc:SWRevealViewController = self.revealViewController() as SWRevealViewController
                rvc.pushFrontViewController (nc, animated: true)
                */
                
                //self.updateWeatherData(json: weatherJSON)
            }
            else {
                print ("Error \(response.result.error ?? "Connection issue" as! Error)")
                self.cityLabel.text = "Connection issue"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("tapped")
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let data:InpuDataController = sender as! InpuDataController
        if let destinationVc = segue.destination as? StationDataTabBarController {
            destinationVc.dataItems = data
            if let targetController = destinationVc.viewControllers![0] as? ChartPageViewController {
                //if let targetController = nc.topViewController as? ChartPageViewController {
                    targetController.dataItems = data
                    let backItem = UIBarButtonItem()
                    backItem.title = "Back"
                    navigationItem.backBarButtonItem = backItem
                //}
            }
            
            if let mapViewController = destinationVc.viewControllers![1] as? PathViewController {
                mapViewController.dataItems = data
            }
            
            
        }
        
    }
    
    
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
    
    func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIActivityIndicatorView {
        let mainContainer: UIView = UIView(frame: viewContainer.frame)
        mainContainer.center = viewContainer.center
        mainContainer.backgroundColor = UIColor.init(hexString: "FFFFFF")
        mainContainer.alpha = 0.5
        mainContainer.tag = 789456123
        mainContainer.isUserInteractionEnabled = false
        
        let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
        viewBackgroundLoading.center = viewContainer.center
        viewBackgroundLoading.backgroundColor = UIColor.init(hexString: "444444")
        viewBackgroundLoading.alpha = 0.5
        viewBackgroundLoading.clipsToBounds = true
        viewBackgroundLoading.layer.cornerRadius = 15
        
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
        activityIndicatorView.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
        if startAnimate!{
            viewBackgroundLoading.addSubview(activityIndicatorView)
            mainContainer.addSubview(viewBackgroundLoading)
            viewContainer.addSubview(mainContainer)
            activityIndicatorView.startAnimating()
        }else{
            for subview in viewContainer.subviews{
                if subview.tag == 789456123{
                    subview.removeFromSuperview()
                }
            }
        }
        return activityIndicatorView
    }

}
