//
//  LocationsStorage.swift
//  Locatics
//
//  Created by Luke Smith on 08/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationStorageInterface {
    var lastVisitedLocation: VisitedLocationData? {get}
    func saveLocationOnDisk(_ location: VisitedLocation)
}

class LocationStorage: LocationStorageInterface {

    var lastVisitedLocation: VisitedLocationData?

    private let appFileSystem: AppFileSystemInterface

    init(appFileSystem: AppFileSystemInterface) {
        self.appFileSystem = appFileSystem
        setupLastVisitedLocation()
    }

    func saveLocationOnDisk(_ location: VisitedLocation) {
        let timestamp = location.date.timeIntervalSince1970
        let fileURL = appFileSystem.buildFullPath(forFileName: "\(timestamp)", inDirectory: .documents)

        appFileSystem.deleteAllFiles(at: .documents)
        appFileSystem.writeFile(containing: location, to: fileURL)

        self.lastVisitedLocation = location
    }
}

private extension LocationStorage {
    func setupLastVisitedLocation() {
        let documentURL = appFileSystem.documentsDirectoryURL()
        let jsonDecoder = JSONDecoder()

        let locationFilesURLs = appFileSystem.contentsOfDirectory(documentURL)
        lastVisitedLocation = locationFilesURLs.compactMap { url -> VisitedLocationData? in
            guard !url.absoluteString.contains(".DS_Store") else { return nil }
            guard let data = try? Data(contentsOf: url) else { return nil }

            return try? jsonDecoder.decode(VisitedLocation.self, from: data)
            }.first
    }
}
