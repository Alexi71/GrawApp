//
//  FlightAnnotation.swift
//  GrawApp
//
//  Created by Alexander Kotik on 11.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import Foundation
import MapKit

class FlightAnnotation : NSObject,MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    var tintColor :UIColor
    
    init(title : String, subTitle : String, coordinate : CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subTitle
        self.tintColor = UIColor.red
    }
    
    
}
