//
//  LocaticsCollectionViewModel.swift
//  Locatics
//
//  Created by Luke Smith on 21/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

protocol LocaticsCollectionViewModelInterface {
    var viewDelegate: LocaticsCollectionViewModelViewDelegate? {get set}

    func locaticsCount() -> Int
    func locaticAtIndex(_ index: IndexPath) -> LocaticCellViewModelInterface
}

protocol LocaticsCollectionViewModelViewDelegate: class {
    func locaticCellViewModelWasAdded(atIndex: Int)
    func locaticCellViewModelWasRemoved(atIndex: Int)
    func locaticCellViewModelWasUpdated(atIndex: Int)

    func reloadData()
}

class LocaticsCollectionViewModel: LocaticsCollectionViewModelInterface {
    weak var viewDelegate: LocaticsCollectionViewModelViewDelegate?

    var locaticCellViewModels: [LocaticCellViewModelInterface] = []

    var locaticStorage: LocaticStorageInterface? {
        didSet {
            locaticStorage?.persistentStorageObserver.add(self)
            fetchAllLocatics()
        }
    }

    func locaticsCount() -> Int {
        return locaticCellViewModels.count
    }

    func locaticAtIndex(_ index: IndexPath) -> LocaticCellViewModelInterface {
        return locaticCellViewModels[index.item]
    }
}

private extension LocaticsCollectionViewModel {
    func fetchAllLocatics() {
        locaticStorage?.fetchLocatics(predicate: nil,
                                      sortDescriptors: nil,
                                      completion: { [weak self] (result) in
                                        switch result {
                                        case .success(let success):
                                            self?.setupLocaticCellViewModels(with: success)
                                        case .failure(let failure):
                                            print(failure.localizedDescription)
                                        }
        })
    }

    func setupLocaticCellViewModels(with locatics: [LocaticData]) {
        for locatic in locatics {
            let newLocaticCellViewModel = LocaticCellViewModel(locatic: locatic)
            locaticCellViewModels.append(newLocaticCellViewModel)
        }

        viewDelegate?.reloadData()
    }

    func index(of locatic: LocaticData) -> Int? {
        locaticCellViewModels.firstIndex { (locaticCellVM) -> Bool in
            return locaticCellVM.locatic.identity == locatic.identity
        }
    }
}

extension LocaticsCollectionViewModel: LocaticPersistentStorageDelegate {
    func locaticWasInserted(_ insertedLocatic: LocaticData) {
        let newLocaticCellViewModel = LocaticCellViewModel(locatic: insertedLocatic)
        locaticCellViewModels.append(newLocaticCellViewModel)

        let newItemIndex = locaticCellViewModels.count - 1
        viewDelegate?.locaticCellViewModelWasAdded(atIndex: newItemIndex)
    }

    func locaticWasUpdated(_ updatedLocatic: LocaticData) {
        guard let updateLocaticIndex = index(of: updatedLocatic) else { return }
        locaticCellViewModels.remove(at: updateLocaticIndex)

        let updatedLocaticCellViewModel = LocaticCellViewModel(locatic: updatedLocatic)
        locaticCellViewModels.insert(updatedLocaticCellViewModel, at: updateLocaticIndex)

        viewDelegate?.locaticCellViewModelWasUpdated(atIndex: updateLocaticIndex)
    }

    func locaticWasDeleted(_ deletedLocatic: LocaticData) {
        guard let deleteLocaticIndex = index(of: deletedLocatic) else { return }
        locaticCellViewModels.remove(at: deleteLocaticIndex)

        viewDelegate?.locaticCellViewModelWasRemoved(atIndex: deleteLocaticIndex)
    }
}
