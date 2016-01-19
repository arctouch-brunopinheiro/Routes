//
//  Route.swift
//  Routes
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Marcone Magnus
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import Foundation

/**
 Encapsulate Route's properties.
*/
class Route {
    
    /// The Route's short name. Ex: 131
    var shortName : String
    
    /// The Route id
    var id : Int
    
    /// The Route's agency id.
    var agencyId : Int
    
    /// The Route's long name. Ex: UFSC SEMI DIRETO
    var longName : String
    
    /// Holds the date of the last time the route has been modified.
    var lastModifiedDate : NSDate
    
    /**
     Initializes the `Route` instance with the specified parameters.
     - parameter shortName:            The short name given to the route.
     - parameter id:                   The Route Id.
     - parameter agencyId:             The Agency Id.
     - parameter longName:             The Route long name.
     - parameter lastModifiedDate:                   The last date Route has been modified.
     */
    init (shortName: String, id : Int, agencyId : Int, longName : String, lastModifiedDate: NSDate) {
        self.shortName = shortName
        self.id = id
        self.agencyId = agencyId
        self.longName = longName
        self.lastModifiedDate = lastModifiedDate
    }
}