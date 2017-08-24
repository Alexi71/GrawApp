//
//  StationViewController.swift
//  
//
//  Created by Alexander Kotik on 24.08.17.
//

import UIKit
import FirebaseDatabase
import MapKit


class StationViewController:
UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDelegate,
UITableViewDataSource{

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    var manager = CLLocationManager()
    var stationItems : [Station] = []
    
    
    
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
        
        

        InitializeDatabase()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
    func InitializeDatabase()  {
        Database.database().reference().child("station").observe(.childAdded) { (snapshot) in
            if let stations = snapshot.value as? NSDictionary {
                let item :Station = Station()
                if let id = stations["Id"] as?  String {
                    item.id = id
                }
                if let name = stations["Name"] as? String {
                    item.name = name
                }
                if let city = stations["City"] as? String {
                    item.city = city
                }
                if let country = stations["Country"] as? String {
                    item.country = country
                }
                
                if let latitude = stations["Latitude"] as? String {
                    item.latitude = latitude
                }
                if let longitude = stations["Longitude"] as? String {
                    item.longitude = longitude
                }
                if let altitude = stations["Altitude"] as? String {
                    item.altitude = altitude
                }
                
                self.stationItems.append(item)
                
                print ("id is: \(item.id)")
                self.tableView.reloadData()
                
            }
        }
        
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = stationItems[indexPath.row].name
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = stationItems[indexPath.row]
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

}
