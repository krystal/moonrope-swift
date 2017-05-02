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
    open var userInfo : [String:Any?] = [:]
    open var beforeCallbacks : [(MoonropeRequest) -> (Void)] = []
    open var afterCallbacks : [(MoonropeRequest) -> (Void)] = []

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
        self.make(path, withParams: [String:Any?]())
    }

    open func make(_ path:String, withParams params: [String:Any?]) {
        type(of: self).delegate?.moonrope(self, willMakeRequest: path, withParams: params)
        self.beforeCallbacks.forEach { (method) in method(self) }
        self.delegate?.moonrope(self, willMakeRequest: path, withParams: params)
        
        self.client.makeRequest(path, withParams: params) {
            response in
            type(of: self).delegate?.moonrope(self, didMakeRequest: response)
            self.afterCallbacks.forEach { (method) in method(self) }
            self.delegate?.moonrope(self, didMakeRequest: response)

            switch(response) {
            case .success(data: let responseData, flags: let flags):
                type(of: self).delegate?.moonrope(self, didSucceedWith: responseData, andFlags: flags)
                self.delegate?.moonrope(self, didSucceedWith: responseData, andFlags: flags)

            case .failure(message: let failureMessage):
                type(of: self).delegate?.moonrope(self, didNotSucceed: response)
                type(of: self).delegate?.moonrope(self, didFail: failureMessage)
                self.delegate?.moonrope(self, didNotSucceed: response)
                self.delegate?.moonrope(self, didFail: failureMessage)

            case .error(errorCode: let errorCode, data: let errorData):
                type(of: self).delegate?.moonrope(self, didNotSucceed: response)
                type(of: self).delegate?.moonrope(self, didError: errorCode, andData: errorData)
                self.delegate?.moonrope(self, didNotSucceed: response)
                self.delegate?.moonrope(self, didError: errorCode, andData: errorData)
            }
        }
    }
}
