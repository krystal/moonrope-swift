//
//  MoonropeRequest.swift
//  MoonropeClient
//
//  Created by Adam Cooke on 08/10/2015.
//  Copyright © 2015 Adam Cooke. All rights reserved.
//

import Foundation

public class MoonropeRequest {

    let client : MoonropeClient
    public var identifier : String?
    public var delegate : MoonropeRequestDelegate?
    public static var delegate : MoonropeRequestDelegate?
    public var userInfo : [String:Any?] = [:]
    public var beforeCallbacks : [(MoonropeRequest) -> (Void)] = []
    public var afterCallbacks : [(MoonropeRequest) -> (Void)] = []

    init(client:MoonropeClient) {
        self.client = client
    }

    convenience init(client:MoonropeClient, withIdentifier identifier: String) {
        self.init(client: client)
        self.identifier = identifier
    }

    convenience init(client:MoonropeClient, withIdentifier identifier: String, andDelegate delegate: MoonropeRequestDelegate) {
        self.init(client: client, withIdentifier: identifier)
        self.delegate = delegate
    }

    public func make(_ path:String) {
        self.make(path, withParams: [String:Any?]())
    }

    public func make(_ path:String, withParams params: [String:Any?]) {
        type(of: self).delegate?.moonrope(request: self, willMakeRequest: path, withParams: params)
        self.beforeCallbacks.forEach { (method) in method(self) }
        self.delegate?.moonrope(request: self, willMakeRequest: path, withParams: params)
        
        self.client.makeRequest(path: path, withParams: params) {
            response in
            type(of: self).delegate?.moonrope(request: self, didMakeRequest: response)
            self.afterCallbacks.forEach { (method) in method(self) }
            self.delegate?.moonrope(request: self, didMakeRequest: response)

            switch(response) {
            case .Success(data: let responseData, flags: let flags):
                type(of: self).delegate?.moonrope(request: self, didSucceedWith: responseData, andFlags: flags)
                self.delegate?.moonrope(request: self, didSucceedWith: responseData, andFlags: flags)

            case .Failure(message: let failureMessage):
                type(of: self).delegate?.moonrope(request: self, didNotSucceed: response)
                type(of: self).delegate?.moonrope(request: self, didFail: failureMessage)
                self.delegate?.moonrope(request: self, didNotSucceed: response)
                self.delegate?.moonrope(request: self, didFail: failureMessage)

            case .Error(errorCode: let errorCode, data: let errorData):
                type(of: self).delegate?.moonrope(request: self, didNotSucceed: response)
                type(of: self).delegate?.moonrope(request: self, didError: errorCode, andData: errorData)
                self.delegate?.moonrope(request: self, didNotSucceed: response)
                self.delegate?.moonrope(request: self, didError: errorCode, andData: errorData)
            }
        }
    }
}
