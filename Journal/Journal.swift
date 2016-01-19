//
//  Journal.swift
//  Journal
//
//  Created by Meiqi You on 20/08/2015.
//  Copyright (c) 2015 Meiqi You. All rights reserved.
//

import Foundation
import Photos
import CoreData
import MapKit

//@objc(Journal)

class Journal: NSManagedObject{
    @NSManaged var title: String
    @NSManaged var body: String
    @NSManaged var images: NSData
    @NSManaged var time: NSDate
    @NSManaged var longitude:String
    @NSManaged var latitude:String
    
    /*init()
    {
        title = ""
        body = ""
        images = [UIImage]()
        time = ""
        longitude = ""
        latitude = ""
    }
    
    
    init(title: String, body: String,images:[UIImage]?,time:String,longitude:String,latitude:String){
        self.title = title
        self.body = body
        self.images = images
        self.time = time
        self.longitude = longitude
        self.latitude = latitude
    }*/
    
    func setImageData(imageCollection:[UIImage]){
        let CDArray = NSMutableArray()
        for img in imageCollection{
            let data:NSData = NSData(data:UIImagePNGRepresentation(img)!)
            CDArray.addObject(data)
        }
        images = NSKeyedArchiver.archivedDataWithRootObject(CDArray)
    }
    
    func getImages() -> [UIImage]{
        var collection:[UIImage]? = [UIImage]()
        if let data = NSKeyedUnarchiver.unarchiveObjectWithData(images) as? NSArray {
            for img in data{
                collection!.append(UIImage(data: img as! NSData)!)
            }
        }
        return collection!
    }
    
    func getTimeAsString() -> String {
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeZone = NSTimeZone()
        return dateFormatter.stringFromDate(NSDate())
    }
    
}
