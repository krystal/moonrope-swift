//
//  MoonropeRequest.swift
//  MoonropeClient
//
//  Created by Adam Cooke on 08/10/2015.
//  Copyright © 2015 Adam Cooke. All rights reserved.
//

import Foundation

open class MoonropeRequest {

    let client : MoonropeClient
    open var identifier : String?
    open var delegate : MoonropeRequestDelegate?
    open static var delegate : MoonropeRequestDelegate?

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

    open func make(_ path:String) {
        self.make(path, withParams: [String:AnyObject]())
    }

    open func make(_ path:String, withParams params: [String:AnyObject]) {
        type(of: self).delegate?.moonropeRequest(self, willMakeRequest: path, withParams: params)
        self.delegate?.moonropeRequest(self, willMakeRequest: path, withParams: params)

        self.client.makeRequest(path, withParams: params) {
            response in
            type(of: self).delegate?.moonropeRequest(self, didMakeRequest: response)
            self.delegate?.moonropeRequest(self, didMakeRequest: response)

            switch(response) {
            case .success(data: let responseData, flags: let flags):
                type(of: self).delegate?.moonropeRequest(self, didSucceedWith: responseData, andFlags: flags as NSDictionary)
                self.delegate?.moonropeRequest(self, didSucceedWith: responseData, andFlags: flags as NSDictionary)

            case .failure(message: let failureMessage):
                type(of: self).delegate?.moonropeRequest(self, didNotSucceed: response)
                type(of: self).delegate?.moonropeRequest(self, didFail: failureMessage)
                self.delegate?.moonropeRequest(self, didNotSucceed: response)
                self.delegate?.moonropeRequest(self, didFail: failureMessage)

            case .error(errorType: let errorType, data: let errorData):
                type(of: self).delegate?.moonropeRequest(self, didNotSucceed: response)
                type(of: self).delegate?.moonropeRequest(self, didErrorWithType: errorType, andData: errorData)
                self.delegate?.moonropeRequest(self, didNotSucceed: response)
                self.delegate?.moonropeRequest(self, didErrorWithType: errorType, andData: errorData)
            }
        }
    }
}

