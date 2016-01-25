//
//  RouteCollection.swift
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
import SwiftyJSON
/**
 A Collection of Routes, initiali it don't have any route. The Collection can search for routes by 
 stop name and also unwrap the json with route data.
*/
class RouteCollection {
    
    /// Holds the routes. It is empty by default.
    var routes : [Route] = [Route]()
    
    /// Holds the API fetcher to search for routes.
    let apiFetcher : APIDataFetcher = APIDataFetcher()
    
    /**
     Search for routes by stop name.
     - parameter stopName            stop name used to search routes.
     - parameter completionHandler   callback used to handle api response.
     */
    
    func findRoutes(withStopName stopName : String, completionHandler: (NSError?) -> ()) {
        apiFetcher.findRoutes(byStopName: stopName).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    self.routes.removeAll()
                    /*
                    This method name is a bit unclear regarding its purpose.
                    By reading this I would expect it to return me the results of its computation, but instead it updates the routes property directly.
                    I'd give this a different name or give it a return type and assign the result to self.routes
                    */
                    self.unwrapRoutes(fromJsonObject: json)
                    completionHandler(nil)
                }
            case .Failure(let error):
                completionHandler(error)
            }
        }
    }
    
    /**
     Unwrap Routes json data comming from api response.
     - parameter json       json containnig Route data.
     */
    private func unwrapRoutes(fromJsonObject json : JSON) {
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'+'zzzz"
        for (_, subJson) : (String, JSON) in json["rows"] {
            if let shortName = subJson["shortName"].string,
                id = subJson["id"].int,
                agencyId = subJson["agencyId"].int,
                longName = subJson["longName"].string,
                lastModifiedDateString = subJson["lastModifiedDate"].string {
                    if let lastModifiedDate = dateFormater.dateFromString(lastModifiedDateString) {
                        let route = Route(shortName: shortName, id: id, agencyId: agencyId,
                            longName: longName, lastModifiedDate: lastModifiedDate)
                        self.routes.append(route)
                    }
            }
        }
    }
}
