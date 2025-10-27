# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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