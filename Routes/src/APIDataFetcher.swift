//
//  APIDataFetcher.swift
//  Routes
//
//  Created by Marcone Magnus on 1/9/16.
//  Copyright © 2016 Marcone Magnus. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIDataFetcher {
    
    let username = "WKD4N7YMA1uiM8V"
    let password = "DtdTtzMLQlA0hk2C1Yi5pLyVIlAQ68"
    let apiQueryPrefix = "https://api.appglu.com/v1/queries/"
    let apiRunSuffix = "run"
    
    lazy var credentialData : NSData = "\(self.username):\(self.password)".dataUsingEncoding(NSUTF8StringEncoding)!
    lazy var base64Credentials : String = self.credentialData.base64EncodedStringWithOptions([])
    
    lazy var header : [String:String] = [
        "Authorization" : "Basic \(self.base64Credentials)",
        "X-AppGlu-Environment" : "staging"
    ]
    
    func findRoutes(byStopName stopName: String) {
        makeAPIRequest(withQuery: "findRoutesByStopName/", andParams: ["stopName" : "%" + stopName + "%" ])
        print(stopName)
    }
    
    func findStops(byRouteId routeId : Int) {
        makeAPIRequest(withQuery: "findStopsByRouteId/", andParams: ["routeId" : "\(routeId)"])
    }
    
    func findDepartures(byRouteId routeId : Int) {
        makeAPIRequest(withQuery: "findDeparturesByRouteId/", andParams: ["routeId" : "\(routeId)"])
    }
    
    private func makeAPIRequest(withQuery query : String, andParams params: AnyObject) {
        
        Alamofire.request(.POST, self.apiQueryPrefix + query + self.apiRunSuffix, parameters: ["params": params], encoding: .JSON, headers: self.header)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("JSON: \(json)")
                    }
                case .Failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    
}
