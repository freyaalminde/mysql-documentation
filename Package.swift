// swift-tools-version: 5.7
import PackageDescription

let package = Package(
  name: "mysql-documentation",
  platforms: [
    .macOS(.v10_15),
  ],
  products: [
    .library(name: "MySQLDocumentation", targets: ["MySQLDocumentation"]),
  ],
  dependencies: [
    .package(url: "https://github.com/vapor/sqlite-nio.git", from: "1.3.4"),
  ],
  targets: [
    .target(
      name: "MySQLDocumentation",
      dependencies: [.product(name: "SQLiteNIO", package: "sqlite-nio")],
      resources: [
        .copy("create_help_tables.sql"),
        .copy("fill_help_tables.sql"),
      ]
    ),
    .testTarget(name: "MySQLDocumentationTests", dependencies: ["MySQLDocumentation"]),
  ]
)
