//
//  MoonropeClient.swift
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
    case Success(data:Any, flags:[String:Any])

    //
    // Returned when there is a Moonrope error. Contains the details of the error
    // and the full data for the response.
    //
    case Error (errorType:String, data:Any)

    //
    // Returned when there was a failure actually communicating successfully
    // with the remote server.
    //
    case Failure(message:String)
}

public class MoonropeClient {

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
    // Generate a new request object with the given details
    //
    public func request(withIdentifier identifier: String, delegate: MoonropeRequestDelegate) -> MoonropeRequest {
        return MoonropeRequest(client: self, withIdentifier: identifier, andDelegate: delegate)
    }

    //
    // Convinence method for making a request without params
    //
    public func makeRequest(path:String, completionHandler:@escaping (MoonropeResponse)->()) {
        self.makeRequest(path: path, withParams: Dictionary(), completionHandler:completionHandler)
    }

    //
    // Make a request to the remote server with the given params and execute the completion
    // handler when complete. The handler will be called with a MoonropeResponse enum containing
    // the appropriate response information.
    //
    public func makeRequest(path:String, withParams params:[String:Any], completionHandler:((MoonropeResponse)->())?) {
        let request = self.createRequest(path: path, params: params)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if error == nil {
                let actualResponse = response as! HTTPURLResponse
                let stringData = String(data: data!, encoding: .utf8)
                if actualResponse.statusCode == 200 {
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                        let moonropeStatus = (jsonData["status"] as! String)
                        let moonropeFlags = (jsonData["flags"] as! [String:Any])

                        if moonropeStatus == "success" {
                            completionHandler?(MoonropeResponse.Success(data: jsonData["data"]!, flags: moonropeFlags))
                        } else {
                            completionHandler?(MoonropeResponse.Error(errorType:moonropeStatus, data: jsonData["data"]!))
                        }

                    } catch {
                        completionHandler?(MoonropeResponse.Failure(message: "Couldn't decode the JSON"))
                    }
                } else {
                    // Something is afoot. This is a failure of the API because all moonrope requests
                    // should have a 200 status.
                    print("Something went wrong with the API: \(stringData) (code: \(actualResponse.statusCode)")
                    completionHandler?(MoonropeResponse.Failure(message: "Moonrope Internal Error"))
                }
            } else {
                completionHandler?(MoonropeResponse.Failure(message: error!.localizedDescription))
            }
        }
        task.resume()
    }

    //
    // Create a new request object for the given path & set of parameters
    //
    func createRequest(path:String, params:[String:Any]) -> NSURLRequest {
        let fullURL = "\(self.httpProtocol)://\(self.httpHost)/api/v\(self.apiVersion)/\(path)"
        let request = NSMutableURLRequest(url: NSURL(string: fullURL)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Moonrope Swift Client", forHTTPHeaderField: "User-Agent")
        let jsonData = self.createJSONFromParams(params)
        if jsonData == nil {
            print("Couldn't successfully create a JSON payload. Sending no params.")
            request.httpBody = "{}".data(using: .utf8)
        } else {
            request.httpBody = jsonData
        }
        for (key, value) in self.headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }

    //
    // Create some JSON data to send to the remote server from the given dictionary of params
    //
    func createJSONFromParams(_ params: [String:Any]) -> Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            return data
        } catch {
            return nil
        }
    }

}
