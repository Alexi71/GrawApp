//
//  RearViewController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 30.08.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit
import SWRevealViewController
import FirebaseAuth

class RearViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableView: UITableView!
    let menuData :[String] = ["add","settings","logout"]
    var userStations : [UserStation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
        self.view.backgroundColor = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
        backView.backgroundColor = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
        getUserStations()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUserStations()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserStations() {
        if let userId = FireBaseHelper.getUserId() {
            userStations = CoreDataHelper.getAllUserStations(userId)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return menuData.count;
        }
        else {
            return userStations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: menuData[indexPath.row]) as! UITableViewCell
            cell.backgroundColor = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
            cell.textLabel?.textColor = UIColor.white
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellStation", for: indexPath)
            
            cell.backgroundColor = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
            cell.textLabel?.textColor = UIColor.white
            if let station = userStations[indexPath.row].station {
                cell.textLabel?.text = station.name
                if userStations[indexPath.row].isdefault {
                     cell.imageView?.image = UIImage(named: "005-facebook-placeholder-for-locate-places-on-maps")
                }
                else {
                     cell.imageView?.image = UIImage(named: "004-placeholder")
                }
               
            }
           
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let menuItem = menuData[indexPath.row]
            if menuItem == "logout" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let nc = storyboard.instantiateViewController(withIdentifier: "home") as! UINavigationController
                revealViewController().pushFrontViewController(nc, animated: true)
                //dismiss(animated: true, completion: nil)
            }
            else if (menuItem == "add") {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let nc = storyboard.instantiateViewController(withIdentifier: "addStationNavigation") as! UINavigationController
                //let vc = nc.topViewController as! AddStationTableViewController
                //vc.activeStation = self.activeStation
                
                let rvc:SWRevealViewController = self.revealViewController() as SWRevealViewController
                rvc.pushFrontViewController(nc, animated: true)
            }
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nc = storyboard.instantiateViewController(withIdentifier: "StationNavigation") as! UINavigationController
            let vc = nc.topViewController as! StationViewController
            let item = userStations[indexPath.row]
            if let user = item.user {
                if let station = item.station {
                    if !CoreDataHelper.updateUserStation(userId: user.id!, stationItem: station) {
                        print ("update not succesfully")
                    }
                }
            }
           
            vc.activeStation = userStations[indexPath.row].station
            
            let rvc:SWRevealViewController = self.revealViewController() as SWRevealViewController
            rvc.pushFrontViewController(nc, animated: true)
        }
    }
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
        return headerView
    }*/
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.white
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "SETTINGS"
        }
        else {
            return "STATIONS"
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
