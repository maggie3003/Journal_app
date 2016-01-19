//
//  JournalAnnotation.swift
//  Journal
//
//  Created by Meiqi You on 4/09/2015.
//  Copyright (c) 2015 Meiqi You. All rights reserved.
//

import UIKit
import MapKit

class JournalAnnotation:NSObject, MKAnnotation {
    let title: String
    let coordinate: CLLocationCoordinate2D
    
    init(title:String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.coordinate = coordinate

        
    }
    
    override init()
    {
        title = ""
        coordinate = CLLocationCoordinate2D()

    }
}
