//
//  Data+CoreDataProperties.swift
//  GrawApp
//
//  Created by Alexander Kotik on 12.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//
//

import Foundation
import CoreData


extension Data {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Data> {
        return NSFetchRequest<Data>(entityName: "Data")
    }

    @NSManaged public var altitude: Double
    @NSManaged public var dewpoint: Double
    @NSManaged public var geopotential: Double
    @NSManaged public var humidity: Double
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var pressure: Double
    @NSManaged public var temperature: Double
    @NSManaged public var time: Double
    @NSManaged public var winddirection: Double
    @NSManaged public var windspeed: Double
    @NSManaged public var dataHasFlight: Ascent?

}
