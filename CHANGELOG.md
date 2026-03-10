## [2.1.1](https://github.com/ionic-team/ion-ios-geolocation/compare/2.1.0...2.1.1) (2026-03-10)


### Bug Fixes

* use Xcode 16 instead of 26 ([#19](https://github.com/ionic-team/ion-ios-geolocation/issues/19)) ([7d8362e](https://github.com/ionic-team/ion-ios-geolocation/commit/7d8362e37a80f4904d1568a6739fa035db42acfc))

# [2.1.0](https://github.com/ionic-team/ion-ios-geolocation/compare/2.0.0...2.1.0) (2026-03-05)


### Features

* add support for heading  ([a1d9bb7](https://github.com/ionic-team/ion-ios-geolocation/commit/a1d9bb7afd490b401e8f521722d4c41cc2531249))

## 2.0.0

### Breaking Changes
- The method `requestSingleLocation()` was replaced with `requestSingleLocation(options: IONGLOCRequestOptionsModel)`.
This change allows adding new configuration parameters in the future without breaking changes.

### Additions
- Added `IONGLOCRequestOptionsModel` to configure timeout (and future parameters).
- Added overload `startMonitoringLocation(options: IONGLOCRequestOptionsModel)`.

### Fixes
- Introduced timeout handling for both `requestSingleLocation` and `startMonitoringLocation`.

## 1.0.2

### Fixes

- Add Package.swift file for out-of-the-box SPM compatibility

## 1.0.1

### Fixes

- Check if location service is already monitoring location when single location is requested

## 1.0.0

### Features
- Add complete implementation, including `getCurrentPosition`, `watchPosition`, and `clearWatch`.
- Create repository.
