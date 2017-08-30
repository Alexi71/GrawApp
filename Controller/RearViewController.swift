//
//  RearViewController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 30.08.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit

class RearViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableView: UITableView!
    let menuData :[String] = ["add","settings","logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
        self.view.backgroundColor = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
        backView.backgroundColor = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: menuData[indexPath.row]) as! UITableViewCell
        cell.backgroundColor = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = menuData[indexPath.row]
        if menuItem == "logout" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nc = storyboard.instantiateViewController(withIdentifier: "home") as! UINavigationController
            revealViewController().pushFrontViewController(nc, animated: true)
            //dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor(red: 2/255, green: 64/255, blue: 123/255, alpha: 1.0)
        return headerView
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
