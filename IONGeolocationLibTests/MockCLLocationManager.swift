import CoreLocation

class MockCLLocationManager: CLLocationManager {
    private(set) var didCallRequestAlwaysAuthorization = false
    private(set) var didCallRequestLocation = false
    private(set) var didCallRequestWhenInUseAuthorization = false
    private(set) var didStartUpdatingLocation = false
    private(set) var didStartUpdatingHeading = false
    private(set) var mockAuthorizationStatus: CLAuthorizationStatus = .notDetermined
    private(set) var mockHeadingFilter: CLLocationDegrees = kCLHeadingFilterNone

    override var authorizationStatus: CLAuthorizationStatus {
        mockAuthorizationStatus
    }

    override var headingFilter: CLLocationDegrees {
        get {
            mockHeadingFilter
        }
        set {
            mockHeadingFilter = newValue
        }
    }

    override func startUpdatingLocation() {
        didStartUpdatingLocation = true
    }

    override func stopUpdatingLocation() {
        didStartUpdatingLocation = false
    }

    override func startUpdatingHeading() {
        didStartUpdatingHeading = true
    }

    override func stopUpdatingHeading() {
        didStartUpdatingHeading = false
    }

    override func requestLocation() {
        didCallRequestLocation = true
    }

    override func requestAlwaysAuthorization() {
        didCallRequestAlwaysAuthorization = true
    }

    override func requestWhenInUseAuthorization() {
        didCallRequestWhenInUseAuthorization = true
    }

    func changeAuthorisation(to status: CLAuthorizationStatus) {
        self.mockAuthorizationStatus = status
        delegate?.locationManagerDidChangeAuthorization?(self)
    }

    func updateLocation(to locations: [CLLocation]) {
        delegate?.locationManager?(self, didUpdateLocations: locations)
    }

    func updateHeading(to heading: CLHeading) {
        delegate?.locationManager?(self, didUpdateHeading: heading)
    }

    func failWhileUpdatingLocation(_ error: Error) {
        delegate?.locationManager?(self, didFailWithError: error)
    }
}
