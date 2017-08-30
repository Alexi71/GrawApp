//
//  Station+CoreDataProperties.swift
//  
//
//  Created by Alexander Kotik on 30.08.17.
//
//

import Foundation
import CoreData


extension Station {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Station> {
        return NSFetchRequest<Station>(entityName: "Station")
    }

    @NSManaged public var altitude: String
    @NSManaged public var city: String
    @NSManaged public var country: String
    @NSManaged public var id: String
    @NSManaged public var key: String
    @NSManaged public var latitude: String
    @NSManaged public var longitude: String
    @NSManaged public var name: String
    @NSManaged public var isdefault: Bool
    @NSManaged public var stationUser: NSSet?

}

// MARK: Generated accessors for stationUser
extension Station {

    @objc(addStationUserObject:)
    @NSManaged public func addToStationUser(_ value: User)

    @objc(removeStationUserObject:)
    @NSManaged public func removeFromStationUser(_ value: User)

    @objc(addStationUser:)
    @NSManaged public func addToStationUser(_ values: NSSet)

    @objc(removeStationUser:)
    @NSManaged public func removeFromStationUser(_ values: NSSet)

}
