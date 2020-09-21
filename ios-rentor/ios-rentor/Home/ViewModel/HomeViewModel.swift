//
//  HomeViewModel.swift
//  ios-rentor
//
//  Created by Thomas on 20/09/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import CoreData
import Combine

internal final class HomeViewModel: ObservableObject {
    
    //MARK: Public Members
    @Published private(set) var dataSources: [RentorEntity] = []
    
    //MARK: Private Members
    private var disposables = Set<AnyCancellable>()
    
    init() {
        self.fetchRentals()
    }
    
    private func fetchRentals() {
        CoreDataManager.sharedInstance.fetchData(type: RentorEntity.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] (value) in
                guard let self = self else { return }
                switch value {
                case .failure(let coreError):
                print(coreError)
                self.dataSources = []
                break
            case .finished:
                break
            }
        }) {[weak self] (value) in
            guard let self = self, let val = value else { return }
            self.dataSources = val
        }.store(in: &self.disposables)
    }
    
}
