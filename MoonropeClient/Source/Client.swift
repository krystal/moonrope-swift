//
//  Client.swift
//  MoonropeClient
//
//  Created by Adam Cooke on 29/09/2015.
//  Copyright © 2015 Adam Cooke. All rights reserved.
//

import Foundation

public enum MoonropeResponse {
    //
    // Returned when the request has been successful. Provides the data and flags.
    //
    case Success(data:AnyObject, flags:[String:AnyObject])
    
    //
    // Returned when there is a Moonrope error. Contains the details of the error
    // and the full data for the response.
    //
    case Error (errorType:String, data:AnyObject)
    
    //
    // Returned when there was a failure actually communicating successfully
    // with the remote server.
    //
    case Failure(message:String)
}

public class Client {

    let httpHost : String
    let httpProtocol : String
    let apiVersion : Int
    var headers : [String:String]
    
    //
    // Initialize by providing the host and protocol
    //
    public init(httpHost:String, withProtocol httpProtocol:String, andAPIVersion version:Int = 1) {
        self.httpHost = httpHost
        self.httpProtocol = httpProtocol
        self.apiVersion = version
        self.headers = Dictionary()
    }

    //
    // Add an HTTP header which will be sent with all requests for this client
    //
    public func addHeader(name:String, withValue value:String) {
        self.headers[name] = value
    }
    
    //
    // Convinence method for making a request without params
    //
    public func makeRequest(path:String, completionHandler:(response:MoonropeResponse)->()) {
        makeRequest(path, withParams: Dictionary(), completionHandler:completionHandler)
    }
    
    // 
    // Make a request to the remote server with the given params and execute the completion 
    // handler when complete. The handler will be called with a MoonropeResponse enum containing
    // the appropriate response information.
    //
    public func makeRequest(path:String, withParams params:[String:AnyObject], completionHandler:(response:MoonropeResponse)->()) -> Bool {
        let request = self.createRequest(path, params: params)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            if error == nil {
                let actualResponse = response as! NSHTTPURLResponse
                let stringData = NSString(data: data!, encoding:NSUTF8StringEncoding) as! String
                if actualResponse.statusCode == 200 {
                    do {
                        let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
                        let moonropeStatus = (jsonData["status"] as! String)
                        let moonropeFlags = (jsonData["flags"] as! [String:AnyObject])
 
                        if moonropeStatus == "success" {
                            completionHandler(response: MoonropeResponse.Success(data: jsonData["data"]!, flags: moonropeFlags))
                        } else {
                            completionHandler(response: MoonropeResponse.Error(errorType:moonropeStatus, data: jsonData["data"]!))
                        }
                        
                    } catch {
                        completionHandler(response: MoonropeResponse.Failure(message: "Couldn't decode the JSON"))
                    }
                } else {
                    // Something is afoot. This is a failure of the API because all moonrope requests
                    // should have a 200 status.
                    print("Something went wrong with the API: \(stringData) (code: \(actualResponse.statusCode)")
                    completionHandler(response: MoonropeResponse.Failure(message: "Moonrope Internal Error"))
                }
            } else {
                completionHandler(response: MoonropeResponse.Failure(message: error!.localizedDescription))
            }
        }
        task.resume()
        return true
    }
    
    // 
    // Create a new request object for the given path & set of parameters
    //
    func createRequest(path:String, params:[String:AnyObject]) -> NSURLRequest {
        let fullURL = "\(self.httpProtocol)://\(self.httpHost)/api/v\(self.apiVersion)/\(path)"
        let request = NSMutableURLRequest(URL: NSURL(string: fullURL)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Moonrope Swift Client", forHTTPHeaderField: "User-Agent")
        let jsonData = self.createJSONFromParams(params)
        if jsonData == nil {
            print("Couldn't successfully create a JSON payload. Sending no params.")
            request.HTTPBody = "{}".dataUsingEncoding(NSUTF8StringEncoding)
        } else {
            request.HTTPBody = jsonData
        }
        for (key, value) in self.headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    //
    // Create some JSON data to send to the remote server from the given dictionary of params
    //
    func createJSONFromParams(params: [String:AnyObject]) -> NSData? {
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions(rawValue: 0))
            return data
        } catch {
            return nil
        }
    }

}
