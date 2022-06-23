// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "GymspotKit",
    platforms: [
      .iOS(.v15),
      .macOS(.v11),
      .watchOS(.v7),
      .tvOS(.v15)
    ],
    products: [
        .library(
            name: "GymspotKit",
            targets: ["GymspotKit"]
        ),
    ],
    dependencies: [
      .package(
          name: "Firebase",
          url: "https://github.com/firebase/firebase-ios-sdk.git",
          .upToNextMajor(from: "9.0.0")
      ),
      .package(url: "https://github.com/CombineCommunity/CombineExt", .upToNextMajor(from: "1.6.0")),
      .package(url: "https://github.com/hmlongco/Resolver", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "GymspotKit",
            dependencies: [
              .product(name: "FirebaseAuth", package: "Firebase", condition: nil),
              .product(name: "FirebaseFirestore", package: "Firebase", condition: nil),
              .product(name: "FirebaseFirestoreSwift", package: "Firebase", condition: nil),
              "CombineExt",
              "Resolver"
            ]
        ),
        .testTarget(
            name: "GymspotKitTests",
            dependencies: ["GymspotKit"]
        ),
    ]
)
