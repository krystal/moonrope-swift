//
//  MoonropeRequestDelegate.swift
//  MoonropeClient
//
//  Created by Adam Cooke on 08/10/2015.
//  Copyright © 2015 Adam Cooke. All rights reserved.
//

import Foundation

public protocol MoonropeRequestDelegate {
    func moonrope(_ request:MoonropeRequest, willMakeRequest path: String, withParams params: [String:Any?])
    func moonrope(_ request:MoonropeRequest, didMakeRequest response: MoonropeResponse)
    func moonrope(_ request:MoonropeRequest, didSucceedWith responseData: Any, andFlags flags: [String:Any?])
    func moonrope(_ request:MoonropeRequest, didFail errorMessage: String)
    func moonrope(_ request:MoonropeRequest, didError errorCode: String?, andData errorData : [String:Any?])
    func moonrope(_ request:MoonropeRequest, didNotSucceed response: MoonropeResponse)
}

public extension MoonropeRequestDelegate {
    func moonrope(_ request:MoonropeRequest, willMakeRequest path: String, withParams params: [String:Any?]) {
        // Nothing by default.
    }

    func moonrope(_ request:MoonropeRequest, didMakeRequest response: MoonropeResponse) {
        // Nothing by default.
    }

    func moonrope(_ request:MoonropeRequest, didSucceedWith responseData: Any, andFlags flags: [String:Any?]) {
        // Nothing by default.
    }

    func moonrope(_ request:MoonropeRequest, didFail errorMessage: String) {
        // Nothing by default.
    }
    
    func moonrope(_ request:MoonropeRequest, didError errorCode: String?, andData errorData : [String:Any?]) {
        // Nothing by default.
    }
    
    func moonrope(_ request:MoonropeRequest, didNotSucceed response: MoonropeResponse) {
        // Nothing by default.
    }
}
