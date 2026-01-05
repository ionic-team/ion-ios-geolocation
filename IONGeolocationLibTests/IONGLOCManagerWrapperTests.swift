import IONGeolocationLib
import XCTest

import Combine
import CoreLocation

final class IONGLOCManagerWrapperTests: XCTestCase {
    private var sut: IONGLOCManagerWrapper!

    private var locationManager: MockCLLocationManager!
    private var servicesChecker: MockServicesChecker!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        locationManager = MockCLLocationManager()
        servicesChecker = MockServicesChecker()
        cancellables = .init()
        sut = .init(locationManager: locationManager, servicesChecker: servicesChecker)
    }

    override func tearDown() {
        sut = nil
        cancellables = nil
        servicesChecker = nil
        locationManager = nil
        super.tearDown()
    }

    // MARK: - 'requestAuthorisation' tests

    func test_requestWhenInUseAuthorisation_triggersALocationManagerWhenInUseAuthorizationRequest() {
        // Given
        XCTAssertFalse(locationManager.didCallRequestWhenInUseAuthorization)

        // When
        sut.requestAuthorisation(withType: .whenInUse)

        // Then
        XCTAssertTrue(locationManager.didCallRequestWhenInUseAuthorization)
    }

    func test_requestAlwaysAuthorisation_triggersALocationManagerAlwaysAuthorizationRequest() {
        // Given
        XCTAssertFalse(locationManager.didCallRequestAlwaysAuthorization)

        // When
        sut.requestAuthorisation(withType: .always)

        // Then
        XCTAssertTrue(locationManager.didCallRequestAlwaysAuthorization)
    }

    func test_locationManagerAuthorisationChangesToWhenInUse_authorisationStatusUpdatesToWhenInUse() {
        // Given
        let expectedStatus = IONGLOCAuthorisation.authorisedWhenInUse
        let expectation = expectation(description: "Authorisation status updated to 'authorisedWhenInUse'.")

        validateAuthorisationStatusPublisher(expectation, expectedStatus)

        // When
        locationManager.changeAuthorisation(to: .authorizedWhenInUse)

        // Then
        waitForExpectations(timeout: 1.0)
    }

    func test_locationManagerAuthorisationChangesToAlways_authorisationStatusUpdatesToAlways() {
        // Given
        let expectedStatus = IONGLOCAuthorisation.authorisedAlways
        let expectation = expectation(description: "Authorisation status updated to 'authorisedAlways'.")

        validateAuthorisationStatusPublisher(expectation, expectedStatus)

        // When
        locationManager.changeAuthorisation(to: .authorizedAlways)

        // Then
        waitForExpectations(timeout: 1.0)
    }

    func test_locationManagerAuthorisationChangesToWhenInUse_andThenToAlways_authorisationStatusUpdatesToAlways() {
        // Given
        locationManager.changeAuthorisation(to: .authorizedWhenInUse)

        let expectedStatus = IONGLOCAuthorisation.authorisedAlways
        let expectationAlways = expectation(description: "Authorisation status updated to 'authorisedAlways'.")
        validateAuthorisationStatusPublisher(expectationAlways, expectedStatus)

        // When
        locationManager.changeAuthorisation(to: .authorizedAlways)

        // Then
        waitForExpectations(timeout: 1.0)
    }

    // MARK: - 'startMonitoringLocation' tests

    func test_startMonitoringLocation_setsUpLocationManager() {
        // Given
        XCTAssertFalse(locationManager.didStartUpdatingLocation)

        // When
        sut.startMonitoringLocation()

        // Then
        XCTAssertTrue(locationManager.didStartUpdatingLocation)
    }

    // MARK: - 'stopMonitoringLocation' tests

    func test_startMonitoringLocation_thenStop_locationManagerStopsMonitoring() {
        // Given
        XCTAssertFalse(locationManager.didStartUpdatingLocation)

        // When
        sut.startMonitoringLocation()

        XCTAssertTrue(locationManager.didStartUpdatingLocation)

        sut.stopMonitoringLocation()

        // Then
        XCTAssertFalse(locationManager.didStartUpdatingLocation)
    }
    
    func test_startMonitoringLocation_timeoutFires() {
        // Given
        let expectation = self.expectation(description: "Timeout should fire for monitoring location")
        
        // When
        let options = IONGLOCRequestOptionsModel(timeout: 1)
        sut.startMonitoringLocation(options: options)
        
        // Then
        validateLocationTimeoutPublisher(expectation)
        
        waitForExpectations(timeout: 1.0)
    }

    // MARK: - 'requestSingleLocation' tests

    func test_requestSingleLocation_returnsIt() {
        // Given
        XCTAssertFalse(locationManager.didCallRequestLocation)

        // When
        sut.requestSingleLocation(options: IONGLOCRequestOptionsModel())

        // Then
        XCTAssertTrue(locationManager.didCallRequestLocation)
    }
    
    func test_requestSingleLocation_timeoutFires() {
        // Given
        let expectation = self.expectation(description: "Timeout should fire for single location request")
        
        // When
        let options = IONGLOCRequestOptionsModel(timeout: 1)
        sut.requestSingleLocation(options: options)
        
        // Then
        validateLocationTimeoutPublisher(expectation)
        
        waitForExpectations(timeout: 1.0)
    }

    // MARK: - 'updateConfiguration' tests

    func test_enableHighAccuracy_thenLocationManagerUpdatesIt() {
        // Given
        XCTAssertEqual(locationManager.desiredAccuracy, CLLocationManager.defaultDesiredAccuracy)
        XCTAssertEqual(locationManager.distanceFilter, CLLocationManager.defaultDistanceFilter)

        // When
        let configuration = IONGLOCConfigurationModel(enableHighAccuracy: true)
        sut.updateConfiguration(configuration)

        // Then
        XCTAssertEqual(locationManager.desiredAccuracy, kCLLocationAccuracyBest)
        XCTAssertEqual(locationManager.distanceFilter, CLLocationManager.defaultDistanceFilter)
    }

    func test_disableHighAccuracy_thenLocationManagerUpdatesIt() {
        // Given
        XCTAssertEqual(locationManager.desiredAccuracy, CLLocationManager.defaultDesiredAccuracy)
        XCTAssertEqual(locationManager.distanceFilter, CLLocationManager.defaultDistanceFilter)

        // When
        let configuration = IONGLOCConfigurationModel(enableHighAccuracy: false)
        sut.updateConfiguration(configuration)

        // Then
        XCTAssertEqual(locationManager.desiredAccuracy, kCLLocationAccuracyThreeKilometers)
        XCTAssertEqual(locationManager.distanceFilter, CLLocationManager.defaultDistanceFilter)
    }

    func test_setMinimumUpdateDistanceInMeters_thenLocationManagerUpdatesIt() {
        // Given
        XCTAssertEqual(locationManager.desiredAccuracy, CLLocationManager.defaultDesiredAccuracy)
        XCTAssertEqual(locationManager.distanceFilter, CLLocationManager.defaultDistanceFilter)

        // When
        let configuration = IONGLOCConfigurationModel(enableHighAccuracy: true, minimumUpdateDistanceInMeters: 10)
        sut.updateConfiguration(configuration)

        // Then
        XCTAssertEqual(locationManager.desiredAccuracy, kCLLocationAccuracyBest)
        XCTAssertEqual(locationManager.distanceFilter, 10)
    }

    // MARK: - 'areLocationServicesEnabled' tests

    func test_enableLocationServices_updatesLocationManager() {
        // Given
        XCTAssertFalse(sut.areLocationServicesEnabled())

        // When
        servicesChecker.enableLocationServices()

        // Then
        XCTAssertTrue(sut.areLocationServicesEnabled())
    }

    func test_disableLocationServices_updatesLocationManager() {
        // Given
        XCTAssertFalse(sut.areLocationServicesEnabled())

        // When
        servicesChecker.enableLocationServices()

        XCTAssertTrue(sut.areLocationServicesEnabled())

        servicesChecker.disableLocationServices()

        // Then
        XCTAssertFalse(sut.areLocationServicesEnabled())
    }

    // MARK: - Location Monitoring Tests

    func test_locationIsUpdated_locationManagerTriggersNewPosition() {
        // Given
        let expectedLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        let expectedPosition = IONGLOCPositionModel.create(from: expectedLocation)
        let expectation = expectation(description: "Location updated.")

        validateCurrentLocationPublisher(expectation, expectedPosition)

        // When
        locationManager.updateLocation(to: [expectedLocation])

        // Then
        waitForExpectations(timeout: 1.0)
    }

    func test_locationIsUpdatedTwice_locationManagerTriggersLatestPosition() {
        // Given
        let firstLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        let expectedLocation = CLLocation(latitude: 48.8859, longitude: -111.3083)
        let expectedPosition = IONGLOCPositionModel.create(from: expectedLocation)
        let expectation = expectation(description: "Location updated.")

        validateCurrentLocationPublisher(expectation, expectedPosition)

        // When
        locationManager.updateLocation(to: [firstLocation, expectedLocation])

        // Then
        waitForExpectations(timeout: 1.0)
    }

    func test_locationIsUpdated_andThenAgain_locationManagerTriggersLatestPosition() {
        // Given
        let firstLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        locationManager.updateLocation(to: [firstLocation])

        let expectedLocation = CLLocation(latitude: 48.8859, longitude: -111.3083)
        let expectedPosition = IONGLOCPositionModel.create(from: expectedLocation)
        let expectation = expectation(description: "Location updated.")
        validateCurrentLocationPublisher(expectation, expectedPosition)

        // When
        locationManager.updateLocation(to: [expectedLocation])

        // Then
        waitForExpectations(timeout: 1.0)
    }

    func test_locationIsMissing_locationManagerTriggersError() {
        // Given
        let noLocationData = [CLLocation]()
        let expectation = expectation(description: "Location missing data.")

        validateCurrentLocationPublisher(expectation)

        // When
        locationManager.updateLocation(to: noLocationData)

        // Then
        waitForExpectations(timeout: 1.0)
    }

    func test_locationUpdateFailes_locationManagerTriggersError() {
        // Given
        let mockError = MockLocationUpdateError.locationUpdateFailed
        let expectation = expectation(description: "Location update failed.")

        validateCurrentLocationPublisher(expectation)

        // When
        locationManager.failWhileUpdatingLocation(mockError)

        // Then
        waitForExpectations(timeout: 1.0)
    }

    // MARK: - Heading Tests

    func test_startMonitoringLocation_startsUpdatingHeading() {
        // Given
        XCTAssertFalse(locationManager.didStartUpdatingHeading)

        // When
        sut.startMonitoringLocation()

        // Then
        XCTAssertTrue(locationManager.didStartUpdatingHeading)
    }

    func test_startMonitoringLocationWithOptions_startsUpdatingHeading() {
        // Given
        XCTAssertFalse(locationManager.didStartUpdatingHeading)

        // When
        let options = IONGLOCRequestOptionsModel(timeout: 1000)
        sut.startMonitoringLocation(options: options)

        // Then
        XCTAssertTrue(locationManager.didStartUpdatingHeading)
    }

    func test_stopMonitoringLocation_stopsUpdatingHeading() {
        // Given
        sut.startMonitoringLocation()
        XCTAssertTrue(locationManager.didStartUpdatingHeading)

        // When
        sut.stopMonitoringLocation()

        // Then
        XCTAssertFalse(locationManager.didStartUpdatingHeading)
    }

    func test_locationUpdateWithHeading_includesHeadingInPositionModel() {
        // Given
        let expectedLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        let expectedHeading = createMockHeading(magneticHeading: 90.0, trueHeading: 92.0, headingAccuracy: 1.0)
        let expectedPosition = IONGLOCPositionModel.create(from: expectedLocation, heading: expectedHeading)
        let expectation = expectation(description: "Location with heading updated.")

        sut.currentLocationPublisher
            .dropFirst()
            .sink(receiveCompletion: { _ in }, receiveValue: { position in
                if position.magneticHeading == expectedPosition.magneticHeading && position.trueHeading == expectedPosition.trueHeading {
                    XCTAssertEqual(position, expectedPosition)
                    expectation.fulfill()
                }
            })
            .store(in: &cancellables)

        // When
        locationManager.updateLocation(to: [expectedLocation])
        locationManager.updateHeading(to: expectedHeading)

        // Then
        waitForExpectations(timeout: 1.0)
    }

    func test_headingUpdateWithoutLocation_doesNotUpdatePositionModel() {
        // Given
        let heading = createMockHeading(magneticHeading: 180.0, trueHeading: 182.0, headingAccuracy: 1.0)
        var updateCount = 0
        let expectation = expectation(description: "No update should occur.")
        expectation.isInverted = true

        sut.currentLocationPublisher
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in
                updateCount += 1
                expectation.fulfill()
            })
            .store(in: &cancellables)

        // When
        locationManager.updateHeading(to: heading)

        // Then
        waitForExpectations(timeout: 0.5)
        XCTAssertEqual(updateCount, 0)
    }

    func test_headingUpdateAfterLocationUpdate_updatesPositionModelWithNewHeading() {
        // Given
        let location = CLLocation(latitude: 37.7749, longitude: -122.4194)
        let firstHeading = createMockHeading(magneticHeading: 90.0, trueHeading: 92.0, headingAccuracy: 1.0)
        let secondHeading = createMockHeading(magneticHeading: 180.0, trueHeading: 182.0, headingAccuracy: 1.0)
        let expectedPosition = IONGLOCPositionModel.create(from: location, heading: secondHeading)
        let expectation = expectation(description: "Position updated with new heading.")

        locationManager.updateLocation(to: [location])
        locationManager.updateHeading(to: firstHeading)

        validateCurrentLocationPublisher(expectation, expectedPosition)

        // When
        locationManager.updateHeading(to: secondHeading)

        // Then
        waitForExpectations(timeout: 1.0)
    }

    func test_locationUpdatePreservesExistingHeading() {
        // Given
        let firstLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        let secondLocation = CLLocation(latitude: 48.8859, longitude: -111.3083)
        let heading = createMockHeading(magneticHeading: 270.0, trueHeading: 272.0, headingAccuracy: 1.0)
        let expectedPosition = IONGLOCPositionModel.create(from: secondLocation, heading: heading)
        let expectation = expectation(description: "Location updated with preserved heading.")

        locationManager.updateLocation(to: [firstLocation])
        locationManager.updateHeading(to: heading)

        validateCurrentLocationPublisher(expectation, expectedPosition)

        // When
        locationManager.updateLocation(to: [secondLocation])

        // Then
        waitForExpectations(timeout: 1.0)
    }

    func test_headingFilterIsSetToOneDegree() {
        // Given
        XCTAssertEqual(locationManager.headingFilter, kCLHeadingFilterNone)

        // When
        sut.startMonitoringLocation()

        // Then
        XCTAssertEqual(locationManager.headingFilter, 1.0)
    }

    func test_positionModelWithoutHeading_hasDefaultHeadingValues() {
        // Given
        let location = CLLocation(latitude: 37.7749, longitude: -122.4194)
        let expectedPosition = IONGLOCPositionModel.create(from: location)
        let expectation = expectation(description: "Location without heading updated.")

        validateCurrentLocationPublisher(expectation, expectedPosition)

        // When
        locationManager.updateLocation(to: [location])

        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(expectedPosition.magneticHeading, -1.0)
        XCTAssertEqual(expectedPosition.trueHeading, -1.0)
        XCTAssertEqual(expectedPosition.headingAccuracy, -1.0)
    }
}

private extension IONGLOCManagerWrapperTests {
    func validateCurrentLocationPublisher(_ expectation: XCTestExpectation, _ expectedPosition: IONGLOCPositionModel? = nil) {
        sut.currentLocationPublisher
            .sink(receiveCompletion: { completion in
                if expectedPosition == nil, case .failure = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { newPosition in
                XCTAssertEqual(newPosition, expectedPosition)
                expectation.fulfill()
            })
            .store(in: &cancellables)
    }

    func validateAuthorisationStatusPublisher(_ expectation: XCTestExpectation, _ expectedStatus: IONGLOCAuthorisation) {
        sut.authorisationStatusPublisher
            .dropFirst()    // ignore the first value as it's the one set on the constructor.
            .sink { status in
                XCTAssertEqual(status, expectedStatus)
                expectation.fulfill()
            }
            .store(in: &cancellables)
    }
    
    func validateLocationTimeoutPublisher(_ expectation: XCTestExpectation) {
        sut.locationTimeoutPublisher
            .sink { error in
                switch error {
                case .timeout:
                    expectation.fulfill()
                    break
                default:
                    XCTFail("Expected timeout error, got \(error)")
                }
            }
            .store(in: &cancellables)
    }

    func createMockHeading(magneticHeading: Double, trueHeading: Double, headingAccuracy: Double) -> CLHeading {
        let heading = MockCLHeading()
        heading.mockMagneticHeading = magneticHeading
        heading.mockTrueHeading = trueHeading
        heading.mockHeadingAccuracy = headingAccuracy
        return heading
    }
}

private extension CLLocationManager {
    static var defaultDesiredAccuracy = kCLLocationAccuracyBest
    static var defaultDistanceFilter = kCLDistanceFilterNone
}

private enum MockLocationUpdateError: Error {
    case locationUpdateFailed
}

private class MockCLHeading: CLHeading {
    var mockMagneticHeading: Double = 0.0
    var mockTrueHeading: Double = 0.0
    var mockHeadingAccuracy: Double = 0.0

    override var magneticHeading: Double {
        mockMagneticHeading
    }

    override var trueHeading: Double {
        mockTrueHeading
    }

    override var headingAccuracy: Double {
        mockHeadingAccuracy
    }
}
