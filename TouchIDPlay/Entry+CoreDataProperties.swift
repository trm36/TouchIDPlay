//
//  Entry+CoreDataProperties.swift
//  TouchIDPlay
//
//  Created by Taylor Mott on 9/28/16.
//  Copyright © 2016 Mott Applications. All rights reserved.
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry");
    }

    @NSManaged public var title: String?
    @NSManaged public var text: String?
    @NSManaged public var timestamp: NSDate?

}
