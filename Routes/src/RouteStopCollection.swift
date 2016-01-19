//
//  RouteStopCollection.swift
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
 A Collection of Stops, initiali it don't have any stops. The Collection can search for stops by
 route id and also unwrap the json with stop data.
*/
class RouteStopCollection {
    
    /// Vector of stop names.
    var stopNames = [String]()
    
    /// Holds the API fetcher to search for stops.
    let apiFetcher : APIDataFetcher = APIDataFetcher()
    
    /**
     Search for stops by route id.
     - parameter routeId:            rout id used to search stops.
     - parameter completionHandler:   callback used to handle api response.
     */
    func findStops(withRouteId routeId : Int, completionHandler: (NSError?) -> ()) {
        apiFetcher.findStops(byRouteId: routeId).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    self.stopNames.removeAll()
                    self.unwrapStops(fromJsonObject: json)
                    completionHandler(nil)
                }
            case .Failure(let error):
                completionHandler(error)
            }
        }
    }
    
    /**
     Unwrap Stops json data comming from api response.
     - parameter json:       json containnig stops data.
     */
    private func unwrapStops(fromJsonObject json : JSON) {
        for (_, subJson) : (String, JSON) in json["rows"] {
            if let stop = subJson["name"].string {
                self.stopNames.append(stop)
            }
        }
    }
}