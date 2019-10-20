//
//  AppFileSystemTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 08/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest
import CoreLocation

@testable import Locatics
class AppFileSystemTests: XCTestCase {

    var sut: AppFileSystem!

    override func setUp() {
        sut = AppFileSystem()
    }

    override func tearDown() {
        sut.deleteAllFiles(at: .documents)
        sut = nil
        super.tearDown()
    }

    func test_appDirectories_values() {
        XCTAssertEqual(AppDirectories.documents.rawValue, "Documents")
    }

    func test_documentsDirectoryURL_returnsDocumentDirectoryURL() {
        let docURL = sut.documentsDirectoryURL()

        do {
            let actualDocURL = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false)
            XCTAssertEqual(docURL, actualDocURL)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func test_getURL_returnsURLForDirectory() {
        let docURL = sut.getURL(for: .documents)

        XCTAssertEqual(docURL, sut.documentsDirectoryURL())
    }

    func test_buildFullPath_returnsGetURLWithNameComponent() {
        let buildFullPath = sut.buildFullPath(forFileName: "TestName", inDirectory: .documents)
        XCTAssertEqual(buildFullPath, sut.getURL(for: .documents).appendingPathComponent("TestName"))
    }

    func test_writeFile_writesDataToURL() {
        let dataToWrite = saveDataToDocumentsDirectory()

        let getURLsBack = sut.contentsOfDirectory(sut.getURL(for: .documents))
        XCTAssertEqual(getURLsBack.count, 1)

        let jsonDecoder = JSONDecoder()
        let decodedData = getURLsBack.compactMap { url -> MockCLVisit? in
            guard !url.absoluteString.contains(".DS_Store") else {
                XCTFail(".DS_Store should not be available in this directory")
                return nil
            }

            guard let data = try? Data(contentsOf: url) else {
                XCTFail("Could not extract data from url")
                return nil
            }

            return try? jsonDecoder.decode(MockCLVisit.self, from: data)
            }.first

        XCTAssertNotNil(decodedData)

        XCTAssertEqual(decodedData!.coordinate.latitude, dataToWrite.coordinate.latitude)
        XCTAssertEqual(decodedData!.coordinate.longitude, dataToWrite.coordinate.longitude)
    }

    func test_contentsOfDirectory_returnsEmptyArrayOfURLContentsIfNothingSaved() {
        let getURLsBack = sut.contentsOfDirectory(sut.getURL(for: .documents))
        XCTAssertEqual(getURLsBack.count, 0)
    }

    func test_deleteAllFiles_deletesAllFilesInDirectory() {
        _ = saveDataToDocumentsDirectory()
        _ = saveDataToDocumentsDirectory("OtherData")

        let getURLsBack = sut.contentsOfDirectory(sut.getURL(for: .documents))
        XCTAssertEqual(getURLsBack.count, 2)

        sut.deleteAllFiles(at: .documents)

        let newURLsBack = sut.contentsOfDirectory(sut.getURL(for: .documents))
        XCTAssertTrue(newURLsBack.isEmpty)
    }

    func saveDataToDocumentsDirectory(_ fileName: String = "MyData") -> VisitedLocationData {
        let dataToWrite = VisitedLocation(visit: MockCLVisit(), description: "Test")
        let url = sut.buildFullPath(forFileName: fileName, inDirectory: .documents)

        sut.writeFile(containing: dataToWrite, to: url)

        return dataToWrite
    }
}
