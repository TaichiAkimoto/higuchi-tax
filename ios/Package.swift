// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Mendoi",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Mendoi",
            targets: ["Mendoi"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.20.0")
    ],
    targets: [
        .target(
            name: "Mendoi",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ],
            path: "Mendoi",
            exclude: ["MendoiApp.swift"]
        ),
        .testTarget(
            name: "MendoiTests",
            dependencies: ["Mendoi"],
            path: "MendoiTests"
        )
    ]
)
