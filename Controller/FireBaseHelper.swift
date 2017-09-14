//
//  FireBaseHelper.swift
//  GrawApp
//
//  Created by Alexander Kotik on 31.08.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class FireBaseHelper {
    static func getUserId () -> String? {
         if let userId = Auth.auth().currentUser?.uid {
            return userId
        }
         else {
            return nil
        }
    }
    
    static func deleteFlightFromCloud(flightData :FlightData, stationKey : String) {
        
        let urlDeleted = Storage.storage().reference(forURL: flightData.url)
        urlDeleted.delete { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        if !flightData.url100.isEmpty {
            let url100Deleted = Storage.storage().reference(forURL: flightData.url100)
            url100Deleted.delete { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        
        if !flightData.urlEnd.isEmpty {
            let urlEndDeleted = Storage.storage().reference(forURL: flightData.urlEnd)
            urlEndDeleted.delete { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        
        
        Database.database().reference().child("station").child(stationKey)
            .child("flights").child(flightData.key).removeValue { (error, reference) in
                if let error = error  {
                    print(error.localizedDescription)
                }
        }
        
    }
}
