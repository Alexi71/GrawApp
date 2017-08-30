//
//  User+CoreDataProperties.swift
//  
//
//  Created by Alexander Kotik on 30.08.17.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String?
    @NSManaged public var userstation: NSSet?

}

// MARK: Generated accessors for userstation
extension User {

    @objc(addUserstationObject:)
    @NSManaged public func addToUserstation(_ value: Station)

    @objc(removeUserstationObject:)
    @NSManaged public func removeFromUserstation(_ value: Station)

    @objc(addUserstation:)
    @NSManaged public func addToUserstation(_ values: NSSet)

    @objc(removeUserstation:)
    @NSManaged public func removeFromUserstation(_ values: NSSet)

}
