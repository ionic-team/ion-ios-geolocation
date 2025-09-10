// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "IONGeolocationLib",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "IONGeolocationLib",
            targets: ["IONGeolocationLib"]
        )
    ],
    targets: [
        .target(
            name: "IONGeolocationLib",
            path: "IONGeolocationLib"
        ),
        .testTarget(
            name: "IONGeolocationLibTests",
            dependencies: ["IONGeolocationLib"],
            path: "IONGeolocationLibTests"
        )
    ]
)