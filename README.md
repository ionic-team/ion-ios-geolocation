# ion-ios-geolocation

A Swift library for iOS that provides simple, reliable access to device GPS capabilities. Get location data, monitor position changes, and manage location services with a clean, modern API.

[![License](https://img.shields.io/cocoapods/l/IONGeolocationLib.svg)](https://cocoapods.org/pods/IONGeolocationLib)
[![Version](https://img.shields.io/cocoapods/v/IONGeolocationLib.svg)](https://cocoapods.org/pods/IONGeolocationLib)
[![Platform](https://img.shields.io/cocoapods/p/IONGeolocationLib.svg)](https://cocoapods.org/pods/IONGeolocationLib)

## Requirements

- iOS 14.0+
- Swift 5.0+
- Xcode 15.0+

## Installation

### CocoaPods

`ion-ios-geolocation` is available through [CocoaPods](https://cocoapods.org). Add this to your Podfile:

```ruby
pod 'IONGeolocationLib', '~> 2.0.0'  # Use the latest 2.0.x version
```

## Quick Start

This library is currently used by the Geolocation Plugin for OutSystems' [Cordova](https://github.com/ionic-team/cordova-outsystems-geolocation) and [Capacitor](https://github.com/ionic-team/outsystems-geolocation) Plugins. Please check the library usage there for real use-case scenarios.

## Features

All the library's features are split in 4 different protocols. Each are detailed in the following subsections:
- `IONGLOCServicesChecker`
- `IONGLOCAuthorisationHandler`
- `IONGLOCSingleLocationHandler`
- `IONGLOCMonitorLocationHandler`
- `IONGLOCRequestOptionsModel`

There's also the typealias `IONGLOCService` that merges all protocols together. Its concrete implementation is achieved by the `IONGLOCManagerWrapper` class.

### `IONGLOCServicesChecker`

The sole goal of `IONGLOCServicesChecker` is to verify if the location services have been enabled on the device.

#### Check if Location Services are Enabled

```swift
func areLocationServicesEnabled() -> Bool
```

Returns a Boolean value indicating whether location services are enabled on the device.


### `IONGLOCAuthorisationHandler`

Manages all authorisation status logic related with location. It's composed by the following:
- a property that indicates the app's at-the-moment authorisation status to use location services;
- a publisher that delivers all authorisation status updates to its subscribers;
- a method that requests the user's permission to use location services.

Authorisation is vital to receive location-related information. The user needs to be prompted to grant permission to the app to use location services. 

#### Location Services' Authorisation Status Property

```swift
var authorisationStatus: IONGLOCAuthorisation
```

It returns the at-the-moment authorisation status to use the device's location services. The following are the possible values:
- `notDetermined`: User hasn't chosen whether the app can use location services. This is the property's default value;
- `restricted`: App is not authorized to use location services;
- `denied`: User denied the use of location services for the app or globally;
- `authorisedAlways`: User authorized the app to start location services at any time;
- `authorisedWhenInUse`: User authorized the app to start location services while it is in use.

#### Location Services' Authorisation Status Publisher

```swift
var authorisationStatusPublisher: Published<IONGLOCAuthorisation>.Publisher
```

It returns a publisher that delivers all authorisation status updates to whoever subscribes to it. The `authorisationStatus` values are the elements that can be emitted by `authorisationStatusPublisher`.

#### Request User's Permission to Use Location Services

```
func requestAuthorisation(withType authorisationType: IONGLOCAuthorisationRequestType)
```

Requests the user’s permission to use location services. There are two types of authorisation that can be requested:
- `always`: Requests the user’s permission to use location services regardless of whether the app is in use;
- `whenInUse`: Requests the user’s permission to use location services while the app is in use.

### `IONGLOCLocationHandler`

Manages all location-related information. It's composed by the following:
- a property that retrieves the device's at-the-moment location position. It can be `nil`  if there hasn't been a request or in case of some issue occurring while fetching it;
- a publisher that delivers all location updates to its subscribers. This includes successful updates or the error it occurred while updating.
- a method that updates two conditions that influence how the location updates are performed:
   - the location data accuracy the app wants to receive;
   - the minimum distance the device must move horizontally before an update event is generated. The distance is measured in meters (m). 

`IONGLOCLocationHandler` serves has the base for both `IONGLOCSingleLocationHandler` and `IONGLOCMonitorLocationHandler`. More on both later.

#### Current Location Property

```swift
var currentLocation: IONGLOCPositionModel?
```

It returns the device's latest fetched location position. It can be `nil` if there hasn't been a request or in case of some issue occuring while fetching it. 
`IONGLOCPositionModel` is composed by the following properties:
- `altitude`: Altitude above mean sea level, measured in meters (m);
- `course`: Direction in which the device is travelling, measured in degrees (º) and relative to due north;
- `horizontalAccuracy`: Radius of uncertainty, measured in meters (m);
- `latitude`: Latitude of the geographical coordinate, measured in degrees (º) and relative to due north;
- `longitude`: Longitude of the geographical coordinate, measured in degrees (º) and relative to the zero meridian;
- `speed`: Instantaneous speed of the device, measured in meters per second (m/s);
- `timestamp`:  Time at which this location was determined, measured in milliseconds (ms) elapsed since the UNIX epoch (Jan 1, 1970);
- `verticalAccuracy`: Validity of the altitude values and their estimated uncertainty, measured in meters (m).

#### Current Location Publisher

```swift
var currentLocationPublisher: AnyPublisher<IONGLOCPositionModel, IONGLOCLocationError>
```

It returns a publisher that delivers all location updates to whoever subscribes to it. The `currentLocation` values are the elements that can be emitted by `currentLocationPublisher`.

#### Location Timeout Publisher

```swift
var locationTimeoutPublisher: AnyPublisher<IONGLOCLocationError, Never>
```

It returns a publisher that emits a `.timeout` event when a request exceeds the specified timeout in `IONGLOCRequestOptionsModel`.


#### Update the Location Manager's Configuration

```swift
func updateConfiguration(_ configuration: IONGLOCConfigurationModel)
```

Updates two properties that condition how location update events are generated:
- `enableHighAccuracy`: Boolean value that indicates if the app wants location data accuracy to be at its best or not. It needs to be explicitly mentioned by the method callers
- `minimumUpdateDistanceInMeters`: Minimum distance the device must move horizontally before an update event is generated, measured in meters (m). As it's optional, it can be omitted by the method callers.

### `IONGLOCRequestOptionsModel`

Used to configure options for location requests.

- `timeout`: Maximum duration (ms) to wait for a location update. Default is `5000`.  

```swift
let options = IONGLOCRequestOptionsModel(timeout: 10000)

// Single location
locationService.requestSingleLocation(options: options)

// Continuous monitoring
locationService.startMonitoringLocation(options: options)
```

### `IONGLOCSingleLocationHandler`

It's responsible to trigger one-time deliveries of the device's current location. It's composed by the following:
- a method that requests the user's current location position. 

#### Request Device's Current Location

```swift
func requestSingleLocation(options: IONGLOCRequestOptionsModel)
```

The method returns immediately. By calling it, it triggers an update to `currentLocation` and a new element delivery by `currentLocationPublisher`.

**Note:** The signature of `requestSingleLocation` has changed.  
You now need to pass an `IONGLOCRequestOptionsModel` to configure options such as `timeout`.


### `IONGLOCMonitorLocationHandler`

It's responsible for the continuous generation of updates that report the device's current location position. It's composed by the following:
- a method that starts the generation of updates;
- a method that ends the generation of updates. 

#### Start Monitoring the Device's Position

```swift
func startMonitoringLocation(options: IONGLOCRequestOptionsModel)
```
- uses the provided options, e.g., a timeout.

```swift
func startMonitoringLocation()
```
- uses the legacy behavior without any options.

Both methods return immediately. By calling them, they trigger an update to `currentLocation` and signal `currentLocationPublisher` to continuously emit relevant location updates.

#### Stop Monitoring the Device's Position

```swift
func stopMonitoringLocation()
```

The method should be called whenever you no longer need to receive location-related events.

## Error Handling

The library uses `IONGLOCLocationError` for error handling regarding location position updates. Possible errors include:

```swift
enum IONGLOCLocationError: Error {
    case locationUnavailable
    case timeout   
    case other(_ error: Error)
}
```

## Location Data Format

Location updates are delivered as `IONGLOCPositionModel` objects:

```json
{
    "latitude": 37.7749,
    "longitude": -122.4194,
    "altitude": 0.0,
    "horizontalAccuracy": 5.0,
    "verticalAccuracy": 10.0,
    "course": 180.0,
    "speed": 0.0,
    "timestamp": 1641034800000
}
```

## Battery Impact Considerations

- High accuracy mode (`enableHighAccuracy: true`) uses GPS and significantly impacts battery life
- Consider using a larger `minimumUpdateDistanceInMeters` for battery optimization
- Call `stopMonitoringLocation()` when updates are no longer needed

## Background Location

To enable background location updates:

1. Add required background modes to `Info.plist`:
```xml
UIBackgroundModes
    Location updates
```

2. Request "always" authorization:

```swift
locationService.requestAuthorisation(withType: .always)
```

## Troubleshooting

Common issues and solutions:

1. Location updates not received
   - Check authorization status
   - Verify location services are enabled
   - Ensure proper `Info.plist` permissions

2. Poor accuracy
   - Enable high accuracy mode
   - Ensure clear sky view
   - Wait for better GPS signal

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

`ion-ios-geolocation` is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Support

- Report issues on our [Issue Tracker](https://github.com/ionic-team/ion-ios-geolocation/issues)