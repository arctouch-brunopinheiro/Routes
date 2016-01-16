//
//  Route.swift
//  Routes
//
//  Created by Marcone Magnus on 1/4/16.
//  Copyright © 2016 Marcone Magnus. All rights reserved.
//

import Foundation

class Route {
    var shortName : String?
    var id : Int?
    var agencyId : Int?
    var longName : String
    var lastModifiedDate : NSDate?
    
    init (shortName: String, id : Int, agencyId : Int, longName : String, lastModifiedDate: NSDate) {
        self.shortName = shortName
        self.id = id
        self.agencyId = agencyId
        self.longName = longName
        self.lastModifiedDate = lastModifiedDate
    }
}