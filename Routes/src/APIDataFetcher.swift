//
//  APIDataFetcher.swift
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
import Alamofire
/**
 Responsible for access the api on a specific location.
*/
class APIDataFetcher {
    
    /// The username to access the api.
    let username = "WKD4N7YMA1uiM8V"
    
    /// The password to access the api.
    let password = "DtdTtzMLQlA0hk2C1Yi5pLyVIlAQ68"
    
    /// The API URI.
    let apiQueryPrefix = "https://api.appglu.com/v1/queries/"
    
    /// The API Sufix.
    let apiRunSuffix = "run"
    
    /// The credential used to authenticate on the service.
    lazy var credentialData : NSData = "\(self.username):\(self.password)".dataUsingEncoding(NSUTF8StringEncoding)!
    
    /// The 64 base credential.
    lazy var base64Credentials : String = self.credentialData.base64EncodedStringWithOptions([])
    
    /// The Header used to access the service.
    lazy var header : [String:String] = [
        "Authorization" : "Basic \(self.base64Credentials)",
        "X-AppGlu-Environment" : "staging"
    ]
    
    /**
     Searches for Routes with stop name.
     - parameter stopName:     The Stop name.
     - returns:                The API request.
     */
    func findRoutes(byStopName stopName: String) -> Request {
        return makeAPIRequest(withQuery: "findRoutesByStopName/", andParams: ["stopName" : "%" + stopName + "%" ])
    }
    
    /**
     Searches for Stops with route id.
     - parameter routeId:    The Stop id.
     - returns:                The API request.
     */
    func findStops(byRouteId routeId : Int) -> Request {
        return makeAPIRequest(withQuery: "findStopsByRouteId/", andParams: ["routeId" : "\(routeId)"])
    }
    
    /**
     Searches for Departures with stop name.
     - parameter routeId:      The route id.
     - returns:                The API request.
     */
    func findDepartures(byRouteId routeId : Int) -> Request {
        return makeAPIRequest(withQuery: "findDeparturesByRouteId/", andParams: ["routeId" : "\(routeId)"])
    }
    
    /**
     Makes the API Request.
     - parameter:    query: The request query.
     - params:       the params to execute the query.
     - returns:                The API request.
     */
    private func makeAPIRequest(withQuery query : String, andParams params: AnyObject) -> Request{
        
        return Alamofire.request(.POST,
                                 self.apiQueryPrefix + query + self.apiRunSuffix,
                                 parameters: ["params": params],
                                 encoding: .JSON,
                                 headers: self.header)
    }
    
    
}
