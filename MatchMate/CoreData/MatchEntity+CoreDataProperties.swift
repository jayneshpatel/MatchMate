//
//  MatchEntity+CoreDataProperties.swift
//  MatchMate
//
//  Created by Jaynesh Patel on 15/07/25.
//
//

import Foundation
import CoreData


extension MatchEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MatchEntity> {
        return NSFetchRequest<MatchEntity>(entityName: "MatchEntity")
    }

    @NSManaged public var uuid: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var email: String?
    @NSManaged public var age: Int16
    @NSManaged public var imageUrl: String?
    @NSManaged public var status: String?
    @NSManaged public var thumbUrl: String?

}

extension MatchEntity : Identifiable {

}
