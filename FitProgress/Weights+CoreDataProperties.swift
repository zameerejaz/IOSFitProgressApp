//
//  Weights+CoreDataProperties.swift
//  FitProgress
//
//  Created by Zameer Ejaz on 08/07/2019.
//  Copyright © 2019 Zameer Ejaz. All rights reserved.
//
//

import Foundation
import CoreData


extension Weights {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weights> {
        return NSFetchRequest<Weights>(entityName: "Weights")
    }

    @NSManaged public var dateStamp: String?
    @NSManaged public var weekNum: Int32
    @NSManaged public var weightInput: Double

}
