//
//  DepartureCollection.swift
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
 A Collection of Departures, initiali it don't have any Departure. The Collection can search for 
 departure by route id and also unwrap the json with departure data.
 */
class DepartureCollection {
   
    /// the weekday departures schedule.
    var weekdayDepartures = [NSDate]()
    
    /// the satureday departures schedule.
    var saturdayDepartures = [NSDate]()
    
    /// the sunday departures schedule.
    var sundayDepartures = [NSDate]()
    
    /// Holds the API fetcher to search for departures.
    let apiFetcher : APIDataFetcher = APIDataFetcher()
    
    /**
     Search for Departures by route id.
     - parameter routeId:            route id used to search departures.
     - parameter completionHandler:   callback used to handle api response.
     */
    func findDepartures(withRouteId routeId : Int, completionHandler: (NSError?) -> ()) {
        apiFetcher.findDepartures(byRouteId: routeId).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    self.weekdayDepartures.removeAll()
                    self.saturdayDepartures.removeAll()
                    self.sundayDepartures.removeAll()
                    self.unwrapDepartures(fromJsonObject: json)
                    completionHandler(nil)
                }
            case .Failure(let error):
                completionHandler(error)
            }
        }
    }
    
    /**
     Unwrap Departures json data comming from api response.
     - parameter json:       json containnig departures data.
     */
    private func unwrapDepartures(fromJsonObject json : JSON) {
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "HH':'mm"
        for (_, subJson) : (String, JSON) in json["rows"] {
            if let dateString = subJson["time"].string,
                calendarType = subJson["calendar"].string {
                    if let date = dateFormater.dateFromString(dateString) {
                        switch calendarType {
                        case "WEEKDAY":
                            weekdayDepartures.append(date)
                        case "SATURDAY":
                            saturdayDepartures.append(date)
                        case "SUNDAY":
                            sundayDepartures.append(date)
                        default: break
                        }
                        
                    }
            }
        }
    }
}