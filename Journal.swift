//
//  Journal.swift
//  
//
//  Created by Meiqi You on 4/09/2015.
//
//

import Foundation
import CoreData

class Journal: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var body: String
    @NSManaged var time: NSDate
    @NSManaged var images: NSData
    @NSManaged var longitude: String
    @NSManaged var latitude: String

}
