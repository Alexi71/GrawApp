//
//  FireBaseHelper.swift
//  GrawApp
//
//  Created by Alexander Kotik on 31.08.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import Foundation
import FirebaseAuth

class FireBaseHelper {
    static func getUserId () -> String? {
         if let userId = Auth.auth().currentUser?.uid {
            return userId
        }
         else {
            return nil
        }
    }
}
