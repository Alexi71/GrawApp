//
//  MessagesViewController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 12.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit
import Alamofire

class MessagesViewController: MessageBaseViewController {
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        flightData = appDelegate.flightData
        guard let flight = flightData else {
            return
        }
        performSelector(inBackground: #selector(getData), with: flight.url100)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    @objc override func updateTextView() {
        textView.text = content
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
