//
//  AppFileSystem.swift
//  Locatics
//
//  Created by Luke Smith on 08/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

enum AppDirectories: String {
    case documents = "Documents"
}

protocol AppDirectoryNames {
    func documentsDirectoryURL() -> URL
    func getURL(for directory: AppDirectories) -> URL
    func buildFullPath(forFileName name: String, inDirectory directory: AppDirectories) -> URL
}

extension AppDirectoryNames {
    func documentsDirectoryURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    func getURL(for directory: AppDirectories) -> URL {
        switch directory {
        case .documents:
            return documentsDirectoryURL()
        }
    }

    func buildFullPath(forFileName name: String, inDirectory directory: AppDirectories) -> URL {
        return getURL(for: directory).appendingPathComponent(name)
    }
}

protocol AppFileSystemInterface: AppDirectoryNames {
    func writeFile<T: Codable>(containing: T, to url: URL)
    func contentsOfDirectory(_ url: URL) -> [URL]
    func deleteAllFiles(at path: AppDirectories)
}

extension AppFileSystemInterface {
    func writeFile<T: Codable>(containing: T, to url: URL) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(containing)
            try data.write(to: url, options: .atomic)
        } catch {
            print("Error writing to URL - \(error.localizedDescription)")
        }
    }

    func contentsOfDirectory(_ url: URL) -> [URL] {
        var urls: [URL] = []

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            urls += fileURLs
        } catch {
            print("Error getting contents at directory - \(error.localizedDescription)")
        }

        return urls
    }

    func deleteAllFiles(at path: AppDirectories) {
        let fileManager = FileManager.default

        do {
            let urlForDocuments = getURL(for: .documents)
            let filePaths = try fileManager.contentsOfDirectory(at: urlForDocuments, includingPropertiesForKeys: nil)

            for filePath in filePaths {
                try fileManager.removeItem(at: filePath)
            }
        } catch {
            print("Error deleting documents directory - \(error.localizedDescription)")
        }
    }
}

struct AppFileSystem: AppFileSystemInterface {}
