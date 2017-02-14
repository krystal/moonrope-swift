//
//  MoonropeRequestDelegate.swift
//  MoonropeClient
//
//  Created by Adam Cooke on 08/10/2015.
//  Copyright © 2015 Adam Cooke. All rights reserved.
//

import Foundation

public protocol MoonropeRequestDelegate {
    func moonrope(request:MoonropeRequest, willMakeRequest path: String, withParams params: [String:Any?])
    func moonrope(request:MoonropeRequest, didMakeRequest response: MoonropeResponse)
    func moonrope(request:MoonropeRequest, didSucceedWith responseData: Any, andFlags flags: [String:Any?])
    func moonrope(request:MoonropeRequest, didFail errorMessage: String)
    func moonrope(request:MoonropeRequest, didErrorWithType errorType: String, andData errorData : Any)
    func moonrope(request:MoonropeRequest, didErrorWithCode errorCode: String?, andData errorData : [String:Any?])
    func moonrope(request:MoonropeRequest, didNotSucceed response: MoonropeResponse)
}

public extension MoonropeRequestDelegate {
    func moonrope(request:MoonropeRequest, willMakeRequest path: String, withParams params: [String:Any?]) {
        // Nothing by default.
    }

    func moonrope(request:MoonropeRequest, didMakeRequest response: MoonropeResponse) {
        // Nothing by default.
    }

    func moonrope(request:MoonropeRequest, didSucceedWith responseData: Any, andFlags flags: [String:Any?]) {
        // Nothing by default.
    }

    func moonrope(request:MoonropeRequest, didFail errorMessage: String) {
        // Nothing by default.
    }
    
    func moonrope(request:MoonropeRequest, didErrorWithType errorType: String, andData errorData : Any) {
        // Nothing by default.
    }
    
    func moonrope(request:MoonropeRequest, didErrorWithCode errorCode: String?, andData errorData : [String:Any?]) {
        // Nothing by default.
    }

    func moonrope(request:MoonropeRequest, didNotSucceed response: MoonropeResponse) {
        // Nothing by default.
    }
}
