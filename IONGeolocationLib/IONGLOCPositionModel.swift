import CoreLocation

public struct IONGLOCPositionModel: Equatable {
    private(set) public var altitude: Double
    private(set) public var course: Double
    private(set) public var horizontalAccuracy: Double
    private(set) public var latitude: Double
    private(set) public var longitude: Double
    private(set) public var speed: Double
    private(set) public var timestamp: Double
    private(set) public var verticalAccuracy: Double
    private(set) public var magneticHeading: Double?
    private(set) public var trueHeading: Double?
    private(set) public var headingAccuracy: Double?

    private init(altitude: Double, course: Double, horizontalAccuracy: Double, latitude: Double, longitude: Double, speed: Double, timestamp: Double, verticalAccuracy: Double, magneticHeading: Double?, trueHeading: Double?, headingAccuracy: Double?) {
        self.altitude = altitude
        self.course = course
        self.horizontalAccuracy = horizontalAccuracy
        self.latitude = latitude
        self.longitude = longitude
        self.speed = speed
        self.timestamp = timestamp
        self.verticalAccuracy = verticalAccuracy
        self.magneticHeading = magneticHeading
        self.trueHeading = trueHeading
        self.headingAccuracy = headingAccuracy
    }
}

public extension IONGLOCPositionModel {
    static func create(from location: CLLocation, heading: CLHeading? = nil) -> IONGLOCPositionModel {
        var mHeading: Double? = nil
        var tHeading: Double? = nil
        var hAccuracy: Double? = nil
        
        if let heading = heading {
            if heading.magneticHeading >= 0 { mHeading = heading.magneticHeading }
            if heading.trueHeading >= 0 { tHeading = heading.trueHeading }
            if heading.headingAccuracy >= 0 { hAccuracy = heading.headingAccuracy }
        }

        return .init(
            altitude: location.altitude,
            course: location.course,
            horizontalAccuracy: location.horizontalAccuracy,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            speed: location.speed,
            timestamp: location.timestamp.millisecondsSinceUnixEpoch,
            verticalAccuracy: location.verticalAccuracy,
            magneticHeading: mHeading,
            trueHeading: tHeading,
            headingAccuracy: hAccuracy
        )
    }
}

private extension Date {
    var millisecondsSinceUnixEpoch: Double {
        timeIntervalSince1970 * 1000
    }
}
