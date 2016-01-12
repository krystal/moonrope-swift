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

    public func make(path:String) {
        self.make(path, withParams: [String:AnyObject]())
    }

    public func make(path:String, withParams params: [String:AnyObject]) {
        self.dynamicType.delegate?.moonropeRequest(self, willMakeRequest: path, withParams: params)
        self.delegate?.moonropeRequest(self, willMakeRequest: path, withParams: params)

        self.client.makeRequest(path, withParams: params) {
            response in
            self.dynamicType.delegate?.moonropeRequest(self, didMakeRequest: response)
            self.delegate?.moonropeRequest(self, didMakeRequest: response)

            switch(response) {
            case .Success(data: let responseData, flags: let flags):
                self.dynamicType.delegate?.moonropeRequest(self, didSucceedWith: responseData, andFlags: flags)
                self.delegate?.moonropeRequest(self, didSucceedWith: responseData, andFlags: flags)

            case .Failure(message: let failureMessage):
                self.dynamicType.delegate?.moonropeRequest(self, didNotSucceed: response)
                self.dynamicType.delegate?.moonropeRequest(self, didFail: failureMessage)
                self.delegate?.moonropeRequest(self, didNotSucceed: response)
                self.delegate?.moonropeRequest(self, didFail: failureMessage)

            case .Error(errorType: let errorType, data: let errorData):
                self.dynamicType.delegate?.moonropeRequest(self, didNotSucceed: response)
                self.dynamicType.delegate?.moonropeRequest(self, didErrorWithType: errorType, andData: errorData)
                self.delegate?.moonropeRequest(self, didNotSucceed: response)
                self.delegate?.moonropeRequest(self, didErrorWithType: errorType, andData: errorData)
            }
        }
    }
}
