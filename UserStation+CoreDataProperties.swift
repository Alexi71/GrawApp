//
//  UserStation+CoreDataProperties.swift
//  
//
//  Created by Alexander Kotik on 31.08.17.
//
//

import Foundation
import CoreData


extension UserStation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserStation> {
        return NSFetchRequest<UserStation>(entityName: "UserStation")
    }

    @NSManaged public var isdefault: Bool
    @NSManaged public var user: User?
    @NSManaged public var station: Station?

}
