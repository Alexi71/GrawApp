//
//  Ascent+CoreDataProperties.swift
//  GrawApp
//
//  Created by Alexander Kotik on 12.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//
//

import Foundation
import CoreData


extension Ascent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ascent> {
        return NSFetchRequest<Ascent>(entityName: "Ascent")
    }

    @NSManaged public var dataUrl: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var key: String?
    @NSManaged public var temp100Url: String?
    @NSManaged public var tempEndUrl: String?
    @NSManaged public var flightHasData: NSSet?

}

// MARK: Generated accessors for flightHasData
extension Ascent {

    @objc(addFlightHasDataObject:)
    @NSManaged public func addToFlightHasData(_ value: Data)

    @objc(removeFlightHasDataObject:)
    @NSManaged public func removeFromFlightHasData(_ value: Data)

    @objc(addFlightHasData:)
    @NSManaged public func addToFlightHasData(_ values: NSSet)

    @objc(removeFlightHasData:)
    @NSManaged public func removeFromFlightHasData(_ values: NSSet)

}
