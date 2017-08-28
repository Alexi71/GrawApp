//
//  User+CoreDataProperties.swift
//  
//
//  Created by Alexander Kotik on 28.08.17.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String
    @NSManaged public var userstation: Station?

}
