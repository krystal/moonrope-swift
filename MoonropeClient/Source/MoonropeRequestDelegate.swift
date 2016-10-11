//
//  MoonropeRequestDelegate.swift
//  MoonropeClient
//
//  Created by Adam Cooke on 08/10/2015.
//  Copyright © 2015 Adam Cooke. All rights reserved.
//

import Foundation

public protocol MoonropeRequestDelegate {
    func moonropeRequest(_ moonropeRequest:MoonropeRequest, willMakeRequest path: String, withParams params: [String:AnyObject])
    func moonropeRequest(_ moonropeRequest:MoonropeRequest, didMakeRequest response: MoonropeResponse)
    func moonropeRequest(_ moonropeRequest:MoonropeRequest, didSucceedWith responseData: AnyObject, andFlags flags: NSDictionary)
    func moonropeRequest(_ moonropeRequest:MoonropeRequest, didFail errorMessage: String)
    func moonropeRequest(_ moonropeRequest:MoonropeRequest, didErrorWithType errorMessage: String, andData errorData : AnyObject)
    func moonropeRequest(_ moonropeRequest:MoonropeRequest, didNotSucceed response: MoonropeResponse)
}

public extension MoonropeRequestDelegate {
    func moonropeRequest(_ moonropeRequest:MoonropeRequest, willMakeRequest path: String, withParams params: [String:AnyObject]) {
        // Nothing by default.
    }

    func moonropeRequest(_ moonropeRequest:MoonropeRequest, didMakeRequest response: MoonropeResponse) {
        // Nothing by default.
    }

    func moonropeRequest(_ moonropeRequest:MoonropeRequest, didSucceedWith responseData: AnyObject, andFlags flags: NSDictionary) {
        // Nothing by default.
    }

    func moonropeRequest(_ moonropeRequest:MoonropeRequest, didFail errorMessage: String) {
        // Nothing by default.
    }

    func moonropeRequest(_ moonropeRequest:MoonropeRequest, didErrorWithType errorMessage: String, andData errorData : AnyObject) {
        // Nothing by default.
    }

    func moonropeRequest(_ moonropeRequest:MoonropeRequest, didNotSucceed response: MoonropeResponse) {
        // Nothing by default.
    }
}

