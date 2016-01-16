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
    
    func findRoutes(withStopName stopName : String, completionHandler: (NSError?) -> ()) {
        apiFetcher.findRoutes(byStopName: stopName).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    self.routes.removeAll()
                    self.unwrapRoutes(fromJsonObject: json)
                    completionHandler(nil)
                }
            case .Failure(let error):
                completionHandler(error)
            }
        }
    }
    
    private func unwrapRoutes(fromJsonObject json : JSON) {
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'+'zzzz"
        for (_, subJson) : (String, JSON) in json["rows"] {
            let route = Route(shortName: (subJson["shortName"].string)!,
                id: (subJson["id"].int!),
                agencyId: (subJson["agencyId"].int!),
                longName: subJson["longName"].string!,
                lastModifiedDate: dateFormater.dateFromString((subJson["lastModifiedDate"].string!))!)
            self.routes.append(route)
        }
    }
}
