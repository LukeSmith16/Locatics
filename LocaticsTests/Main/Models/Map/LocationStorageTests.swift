//
//  LocationsStorageTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 08/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocationsStorageTests: XCTestCase {

    private var mockAppFileSystem: MockAppFileSystem!
    var sut: LocationStorage!

    override func setUp() {
        mockAppFileSystem = MockAppFileSystem()
        sut = LocationStorage(appFileSystem: mockAppFileSystem)
    }

    override func tearDown() {
        mockAppFileSystem = nil
        sut = nil
        super.tearDown()
    }

    func test_lastVisitedLocation_isNilByDefault() {
        XCTAssertNil(sut.lastVisitedLocation)
    }

    func test_saveLocationOnDisk_callsFileSystemDeleteAndWriteToFile() {
        let visitedLocation = VisitedLocation(visit: MockCLVisit(), description: "test")
        sut.saveLocationOnDisk(visitedLocation)

        XCTAssertTrue(mockAppFileSystem.calledDeleteAllFiles)
        XCTAssertTrue(mockAppFileSystem.calledWriteFile)

        XCTAssertNotNil(sut.lastVisitedLocation)

        guard let lastVisitedLocation = sut.lastVisitedLocation as? VisitedLocation else {
            XCTFail("lastVisitedLocation should be 'VisitedLocation'")
            return
        }

        XCTAssertTrue(lastVisitedLocation === visitedLocation)
    }

    func test_setupLastVisitedLocation_callsContentsOfDirectory() {
        XCTAssertTrue(mockAppFileSystem.calledDocumentsDirectoryURL)
        XCTAssertTrue(mockAppFileSystem.calledContentsOfDirectory)
    }

    func test_setupLastVisitedLocation_setsLastVisitedLocationWhenOneIsPersisted() {
        let visitedLocation = VisitedLocation(visit: MockCLVisit(), description: "test")
        let fileSystem = AppFileSystem()

        sut = LocationStorage(appFileSystem: fileSystem)
        sut.saveLocationOnDisk(visitedLocation)

        sut = LocationStorage(appFileSystem: fileSystem)

        XCTAssertNotNil(sut.lastVisitedLocation)
        XCTAssertEqual(sut.lastVisitedLocation!.latitude, visitedLocation.coordinate.latitude)
        XCTAssertEqual(sut.lastVisitedLocation!.longitude, visitedLocation.coordinate.longitude)
    }
}

private extension LocationsStorageTests {
    class MockAppFileSystem: AppFileSystemInterface {
        var calledDocumentsDirectoryURL = false
        var calledDeleteAllFiles = false
        var calledWriteFile = false
        var calledContentsOfDirectory = false

        func documentsDirectoryURL() -> URL {
            calledDocumentsDirectoryURL = true
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }

        func deleteAllFiles(at path: AppDirectories) {
            calledDeleteAllFiles = true
        }

        func writeFile<T>(containing: T, to url: URL) where T: Decodable, T: Encodable {
            calledWriteFile = true
        }

        func contentsOfDirectory(_ url: URL) -> [URL] {
            calledContentsOfDirectory = true
            return []
        }
    }
}
