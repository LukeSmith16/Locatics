//
//  MockAppFileSystem.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
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
