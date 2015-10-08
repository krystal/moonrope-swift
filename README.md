# Moonrope Swift Client

This is a simple client for communicating with a [Moonrope API](http://github.com/adamcooke/moonrope)
using Swift. Just include this library with CocoaPods and use it as shown below.

The client supports two methods of making requests. You can either use a delegate
based approach or using anonymous functions approach. Both are described below.

## Installation

Probably best to install this with Cocoapods.

## Using with delegation

This is the preferred method of using the library. This example shows how to
set it up to download some data which will be used in a UITableViewController.
It will make the request when a button is pushed and reload the data view when
we have received a result.

```swift
import MoonropeClient

class ExampleViewController : UITableViewController, MoonropeResponseDelegate {

  var widgets : [NSDictionary]?

  @IBAction func makeAPIRequest() {
    // Create a moonrope client instance
    let client = MoonropeClient(httpHost: "api.yourapp.com", withProtocol: "https")
    client.addHeader("X-Auth-Token", withValue: "SomeToken")
    client.addHeader("X-Auth-Secret", withValue: "SomeSecret")

    // Make a request, give it an identifier and set the delegate to the current
    // instance of the class
    let request = client.request("GetWidgets", delegate: self)

    // Kick off the request
    request.make("controller/action", withParams: ["page": 3])
  }

  // This delegate method will be called when any request has completed successfully.
  func moonropeRequest(moonropeRequest:MoonropeRequest, didSucceedWith responseData: AnyObject, andFlags flags: NSDictionary) {
    if moonropeRequest.identifier == "GetWidgets" {
      self.widgets = responseData as! [NSDictionary]
      tableView.reloadData()
    }
  }

  /// This delegate method will be called when a request fails for any reason.
  func moonropeRequest(moonropeRequest:MoonropeRequest, didNotSucceed response: MoonropeResponse) {
    // Show an error or something. You can add your own login for this.
  }

}
```

There are a number of other delegate methods which you can implement. You can
refer to the `MoonropeResponseDelegate` file to see the methods which can be
implement.

You can also specify a global delegate on the `MoonropeRequest` class. This will
allow you to execute methods on any request using the library. You could use this
in the `AppDelegate` to show/hide the activity indicator.

```swift
class AppDelegate: UIResponder, UIApplicationDelegate, MoonropeRequestDelegate {

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    MoonropeRequest.delegate = self
  }

  func moonropeRequest(moonropeRequest: MoonropeRequest, willMakeRequest path: String, withParams params: [String : AnyObject]) {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
  }

  func moonropeRequest(moonropeRequest: MoonropeRequest, didMakeRequest response: MoonropeResponse) {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
  }

}
```

## Using by passing anonymous functions

As an alternative to delegation, you can provide anonymous functions which will
be executed as appropriate and provides a `MoonropeResponse` enum with the
data and type of response.

```swift
import MoonropeClient

// Create a new client instance
let client = MoonropeClient(httpHost: "api.yourapp.com", withProtocol: "https")
client.addHeader("X-Auth-Token", withValue: "SomeToken")
client.addHeader("X-Auth-Secret", withValue: "SomeSecret")

// Make a request to the API
client.makeRequest("controller/action") {
  response in
  switch response {
    case .Success(data: let responseData, flags: let responseFlags):
      // The request has been completed successfully and the data is now
      // available for your use in responseData.

    case .Error(errorType: let typeOfError, data: let responseData):
      // The API returned an error. The type of the error and the data which
      // was provided is available.

    case .Failure(message: let errorMessage):
      // There was a serious error communicating with the API server. This is a
      // connection issue or a fatal error. The human readable error is provided.
  }
}
```
