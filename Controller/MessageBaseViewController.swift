//
//  MassageBaseViewController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 12.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit

class MessageBaseViewController: UIViewController {
    var index :Int = 0
    var flightData : FlightData?
    var content : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func getData(url:String?) {
        
        guard let urlString = url,!urlString.isEmpty else {
            print ("temp  data not available")
            return
        }
        
        if let url = URL(string: urlString) {
            do {
                let contents = try String(contentsOf: url)
                content = contents
                performSelector(onMainThread: #selector(updateTextView), with: nil, waitUntilDone: false)
                print(contents)
            } catch {
                // contents could not be loaded
                print("content could not be loaded")
            }
        } else {
            // the URL was bad!
            print("url was bad")
        }
    }
    
    @objc func updateTextView() {
        //textView.text = content
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
