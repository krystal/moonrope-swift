# Moonrope Swift Client

This is a simple client for communicating with a [Moonrope API](http://github.com/adamcooke/moonrope)
using Swift. Just include this library with CocoaPods and use it as shown below.

```swift
import MoonropeClient

// Create a new client instance
let client = MoonropeClient.Client(httpHost: "api.yourapp.com", withProtocol: "https")
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
