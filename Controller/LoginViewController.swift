//
//  LoginViewController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 18.08.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SWRevealViewController

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordtextField: UITextField!
   
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var lowerButton: UIButton!
    
    var activeStation : Station?
    
    var loginIsActive: Bool = true
    
    
    override func viewDidLoad() {
        
        setControlIsHidden(isHidden: true)
        super.viewDidLoad()
        //CoreDataHelper.deleteAllUsers()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let username = defaults.object(forKey:"username") as? String
        let password = defaults.object(forKey: "password") as? String
        let firstcall = defaults.object(forKey: "firstcall") as? Bool
        //check user defaults and if firstcall after start
        guard let usr = username,let psw = password,
            let firstCall = firstcall,firstCall else {
            setControlIsHidden(isHidden: false)
            return
        }
        
        LoginAndMove(email: usr, password: psw)
    }
        
        
    
    
    
    private func setControlIsHidden(isHidden : Bool) {
        emailTextField.isHidden = isHidden
        passwordtextField.isHidden = isHidden
        topButton.isHidden = isHidden
        lowerButton.isHidden = isHidden
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func upperButtonPressed(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "firstcall")
        if loginIsActive {
            if let email = emailTextField.text {
                if let password = passwordtextField.text {
                    LoginAndMove(email: email, password: password)
                    /*Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            if let errorCode = error?.localizedDescription {
                                self.showError(errorText: errorCode)
                            }
                        }
                        else {
                            // User sign in was successfully
                            
                            self.activeStation = self.GetActiveStation()
                            let defaults = UserDefaults.standard
                            defaults.set(email, forKey: "username")
                            defaults.set(password, forKey: "password")
                            
                            if self.activeStation != nil {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let nc = storyboard.instantiateViewController(withIdentifier: "StationNavigation") as! UINavigationController
                                let vc = nc.topViewController as! StationViewController
                                vc.activeStation = self.activeStation
                                
                                let rvc:SWRevealViewController = self.revealViewController() as SWRevealViewController
                                rvc.pushFrontViewController(nc, animated: true)
                                //self.performSegue(withIdentifier: "StationFlights", sender: nil)
                            }
                            else {
                               self.performSegue(withIdentifier: "AuthToStation", sender: self)
                            }
                            
                        }
                    })*/
                }
            }
            else {
                if let email = emailTextField.text {
                    if let password = passwordtextField.text {
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                if let errorCode = error?.localizedDescription {
                                    self.showError(errorText: errorCode)
                                }
                            }
                            else {
                                self.performSegue(withIdentifier: "AuthToStation", sender: nil)
                            }
                        })
                    }
                }
            }
        }
    }
    
    func LoginAndMove(email: String, password : String ) {
        
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        if let errorCode = error?.localizedDescription {
                            self.showError(errorText: errorCode)
                        }
                    }
                    else {
                        // User sign in was successfully
                        
                        self.activeStation = self.GetActiveStation()
                        let defaults = UserDefaults.standard
                        defaults.set(email, forKey: "username")
                        defaults.set(password, forKey: "password")
                        
                        if self.activeStation != nil {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let nc = storyboard.instantiateViewController(withIdentifier: "StationNavigation") as! UINavigationController
                            let vc = nc.topViewController as! StationViewController
                            vc.activeStation = self.activeStation
                            
                            let rvc:SWRevealViewController = self.revealViewController() as SWRevealViewController
                            rvc.pushFrontViewController(nc, animated: true)
                            //self.performSegue(withIdentifier: "StationFlights", sender: nil)
                        }
                        else {
                            self.performSegue(withIdentifier: "AuthToStation", sender: self)
                        }
                        
                    }
                })
        
    
    }
    
    func GetActiveStation() -> Station? {
        
        if let userId = Auth.auth().currentUser?.uid {
            
           let station = CoreDataHelper.getDefaultStationFromUser(userId: userId)
            return station
        }
        return nil
    }
    
    @IBAction func lowerButtonPressed(_ sender: UIButton) {
        if loginIsActive {
            topButton.setTitle("Sign up", for: .normal)
            lowerButton.setTitle("Login", for: .normal)
            loginIsActive = false
        }
        else {
            topButton.setTitle("Login", for: .normal)
            lowerButton.setTitle("Sign up", for: .normal)
            loginIsActive = true
        }
    }
    
    private func showError(errorText :String) {
        let alervc = UIAlertController(title: "Error", message: errorText, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            alervc.dismiss(animated: true, completion: nil)
        })
        
       
        alervc.addAction(okAction)
        present(alervc, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "AuthToStation" {
            if let destinationVc = segue.destination as? UINavigationController {
                if let targetController = destinationVc.topViewController as? AddStationTableViewController {
                    targetController.activeStation = self.activeStation
                }
            }
        }
        else if segue.identifier == "StationFlights" {
            if let destinationVc = segue.destination as? UINavigationController {
                if let targetController = destinationVc.topViewController as? StationViewController {
                    targetController.activeStation = self.activeStation
                }
            }
        }
    }
    

}
