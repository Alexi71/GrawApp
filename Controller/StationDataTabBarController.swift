//
//  StationDataTabBarController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 10.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit

class StationDataTabBarController: UITabBarController,UITabBarControllerDelegate {
    var dataItems:InpuDataController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let vc = viewController as? PathViewController {
            vc.dataItems = dataItems
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
