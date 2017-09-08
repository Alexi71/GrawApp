//
//  AddStationTableViewController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 25.08.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreData

class AddStationTableViewController: UITableViewController,UISearchBarDelegate {
    var activeStation : Station?
    var stationItems:[StationItem] = []
    var filteredItems: [StationItem] = []
    //var userStations : [UserStation] = []
    var isFiltered = false

    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        if activeStation == nil {
              if let userId = Auth.auth().currentUser?.uid {
                activeStation = CoreDataHelper.getDefaultStationFromUser(userId: userId)
            }
        }
        //ReadUserStations()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        InitializeDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltered {
            return filteredItems.count
        }
        else {
            return stationItems.count
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)

        // Configure the cell...
        var item :StationItem = StationItem()
        if isFiltered {
            item = filteredItems[indexPath.row]
        }
        else {
            item = stationItems[indexPath.row]
        }
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.id
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item :StationItem = StationItem()
        if isFiltered {
            item = filteredItems[indexPath.row]
        }
        else {
            item = stationItems[indexPath.row]
        }
        if let userId = Auth.auth().currentUser?.uid {
            if let station = CoreDataHelper.getStationObject() {
                station.id = item.id
                station.name = item.name
                station.city = item.city
                station.country = item.country
                station.latitude = item.latitude
                station.longitude = item.longitude
                station.altitude = item.altitude
                station.key = item.key
                CoreDataHelper.insertUserWithStation(userId: userId, stationItem: station)
            }
            
            
            //
            
            
           /* let searchRef = Database.database().reference().child("userstations").child(user)
                .child("stations")
                .queryOrdered(byChild: "staionKey").queryEqual(toValue: item.key)
            
            searchRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard snapshot.value is NSNull else {
                    
                    // yes we got the user
                    let user = snapshot.value as! NSDictionary
                    //print("\(user) is exists")
                    return
                }

            })
            print ("Stop")
            /*let userEntry : [String: String] = ["staionKey" : item.key,"isActive":"true"]
            let ref = Database.database().reference()
            ref.child("userstations").child(user).child("stations").childByAutoId().setValue(userEntry, withCompletionBlock: { (error, dbref) in
                if error == nil {
                    print ("user station added successfully")
                }
            })*/*/
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" || searchBar.text == nil {
            isFiltered = false
            view.endEditing(true)
            
        }
        else {
            isFiltered = true
            filteredItems = stationItems.filter({ (sta) -> Bool in
                if (sta.name == searchText || sta.name.range(of: searchText) != nil) ||
                    (sta.id == searchText || sta.id.range(of: searchText) != nil){
                    return true
                }
                else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    //MARK: - Database
    /*
    func ReadUserStations() {
        if let user = Auth.auth().currentUser?.uid {
            
            let searchRef = Database.database().reference().child("userstations").child(user)
                .child("stations")
            
            
            searchRef.observe(.childAdded,  with: { (snapshot) in
                
                if let snap = snapshot.value as? NSDictionary
                {
                    let us = UserStation()
                    if let id = snap["staionKey"] as?  String {
                        us.key = id
                    }
                    if let isActive = snap["isActive"] as?  String {
                        us.isActive = Bool(isActive)!
                    }
                    self.userStations.append(us)
                }
                /*guard snapshot.value is NSNull else {
                 
                 // yes we got the user
                 //let user = snapshot.value as! NSDictionary
                 //print("\(user) is exists")
                 result = true
                 return
                 }*/
                
            })
        }
    }*/
    
    func InitializeDatabase()  {
        Database.database().reference().child("station").observe(.childAdded) { (snapshot) in
            let key = snapshot.key
            
            if let stations = snapshot.value as? NSDictionary {
                let item :StationItem = StationItem()
                item.key = key
                
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
                
                
                
               /* let x = self.userStations.contains(where: { (us) -> Bool in
                    if us.key == item.key {
                        return true
                    }
                    else {
                        return false
                    }
                })*/
                if let coreStation = self.activeStation {
                    if coreStation.id != item.id {
                       self.stationItems.append(item)
                    }
                }
                else {
                    self.stationItems.append(item)
                }
                
                
                
                
                //print ("id is: \(item.id)")
                self.tableView.reloadData()
                
            }
        }
        
    }
    
    func IsStationKeyforUserExists(key :String) -> Bool {
        var result = false
        if let user = Auth.auth().currentUser?.uid {
            
            let searchRef = Database.database().reference().child("userstations").child(user)
                .child("stations")
                .queryOrdered(byChild: "staionKey").queryEqual(toValue: key)
            
            searchRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let snap = snapshot.value as? NSDictionary
                {
                    result = true
                }
                /*guard snapshot.value is NSNull else {
                    
                    // yes we got the user
                    //let user = snapshot.value as! NSDictionary
                    //print("\(user) is exists")
                    result = true
                    return
                }*/
                
            })
        
        }
        return result
    }

}
