//
//  MoonropeRequestDelegate.swift
//  MoonropeClient
//
//  Created by Adam Cooke on 08/10/2015.
//  Copyright © 2015 Adam Cooke. All rights reserved.
//

public protocol MoonropeRequestDelegate {
    func moonropeRequest(moonropeRequest:MoonropeRequest, willMakeRequest path: String, withParams params: [String:AnyObject])
    func moonropeRequest(moonropeRequest:MoonropeRequest, didMakeRequest response: MoonropeResponse)
    func moonropeRequest(moonropeRequest:MoonropeRequest, didSucceedWith responseData: AnyObject, andFlags flags: NSDictionary)
    func moonropeRequest(moonropeRequest:MoonropeRequest, didFail errorMessage: String)
    func moonropeRequest(moonropeRequest:MoonropeRequest, didErrorWithType errorMessage: String, andData errorData : AnyObject)
    func moonropeRequest(moonropeRequest:MoonropeRequest, didNotSucceed response: MoonropeResponse)
}

public extension MoonropeRequestDelegate {
    func moonropeRequest(moonropeRequest:MoonropeRequest, willMakeRequest path: String, withParams params: [String:AnyObject]) {
        // Nothing by default.
    }

    func moonropeRequest(moonropeRequest:MoonropeRequest, didMakeRequest response: MoonropeResponse) {
        // Nothing by default.
    }

    func moonropeRequest(moonropeRequest:MoonropeRequest, didSucceedWith responseData: AnyObject, andFlags flags: NSDictionary) {
        // Nothing by default.
    }

    func moonropeRequest(moonropeRequest:MoonropeRequest, didFail errorMessage: String) {
        // Nothing by default.
    }

    func moonropeRequest(moonropeRequest:MoonropeRequest, didErrorWithType errorMessage: String, andData errorData : AnyObject) {
        // Nothing by default.
    }

    func moonropeRequest(moonropeRequest:MoonropeRequest, didNotSucceed response: MoonropeResponse) {
        // Nothing by default.
    }
}
