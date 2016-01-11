//
//  RouteCollection.swift
//  Routes
//
//  Created by Marcone Magnus on 1/5/16.
//  Copyright © 2016 Marcone Magnus. All rights reserved.
//

import Foundation
import SwiftyJSON

class RouteCollection {
    
    var stopName : String = ""
    
    var routes : [Route] = [Route]()
    
    let apiFetcher : APIDataFetcher = APIDataFetcher()
    
    func findRoutes(withStopName stopName : String) {
        apiFetcher.findRoutes(byStopName: stopName).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    self.wrapRoutes(fromJsonObject: json)
                }
            case .Failure(let error):
                // return error to GUI
                print(error.localizedDescription)
            }
        }
    }
    
    private func wrapRoutes(fromJsonObject json : JSON) {
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'+''Z'"
        
        for (key, subJson) : (String, JSON) in json["rows"] {
            let route = Route(/*shortName: (dictionaryValue["shortName"]?.string)!,
                              id: (dictionaryValue["id"]?.int!)!,
                              agencyId: (dictionaryValue["agencyId"]?.int!)!,*/
                              longName: subJson["longName"].string!/*,
                              lastModifiedDate: dateFormater.dateFromString((dictionaryValue["lasteModifiedDate"]?.string!)!)!*/)
            self.routes.append(route)
            print( "--> \(key) : \(subJson)")
            
            print("----> (longName: \(subJson["longName"].string!))")
        }
    }
}
