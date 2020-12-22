//
//  rentalDBRepository.swift
//  ios-rentor
//
//  Created by Thomas on 17/12/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import Combine
import UIKit
import CoreData

protocol RentalDBRepository {
    
    associatedtype CoreEntity
    associatedtype ModelEntity
    
    func create(with item: ModelEntity) -> AnyPublisher<Void, CoreDataError>
    func delete(with item: ModelEntity) throws
    func update(with item: ModelEntity)
    func fetch() -> AnyPublisher<[ModelEntity], CoreDataError>
    func refresh() -> AnyPublisher<ModelEntity?, CoreDataError>
    func deleteOn(with item: ModelEntity) -> AnyPublisher<Void, CoreDataError>
}

internal final class RealRentalDBRepository: RentalDBRepository {
    private let coreDataManager: CoreDataManager<RentorEntity>
    private let context: NSManagedObjectContext
    
    internal typealias CoreEntity = RentorEntity
    internal typealias ModelEntity = Rentor
    
    internal static let sharedInstance = RealRentalDBRepository()
    
    private init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let request = RentorEntity.fetchRequest() as? NSFetchRequest<RentorEntity> else {
            fatalError("[SIMMO][ERROR] AppDelegate failed CoreDataRental")
        }
        self.context = appDelegate.persistentContainer.viewContext
        request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: true)]
        self.coreDataManager = CoreDataManager<RentorEntity>(request: request,
                                                             context: appDelegate.persistentContainer.viewContext)
    }
    
    internal func create(with item: Rentor) -> AnyPublisher<Void, CoreDataError> {
        guard let rentorObject = item.store(in: self.context) else {
            print("DO WE GET HERE? ")
            return AnyPublisher(Fail<Void, CoreDataError>(error: .createError))
        }
        print("RENTOR = \(item)")
        print("RENTOR OBJECT = \(rentorObject)")
        return self.coreDataManager.create(with: rentorObject)
    }

    internal func refresh() -> AnyPublisher<Rentor?, CoreDataError> {
        return self.coreDataManager.onUpdate()
            .map { Rentor(managedObject: $0) }.mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    internal func update(with item: Rentor) {
        fatalError("[CoreDataRental][update] Not implemented yet")
    }
    
    internal func delete(with item: Rentor) throws {
        if let rentorObject = item.store(in: self.context) {
            try self.coreDataManager.delete(with: rentorObject)
        }
    }
    
    internal func fetch() -> AnyPublisher<[Rentor], CoreDataError> {
        return self.coreDataManager.fetch().map { (rentorEntity) -> [Rentor] in
            var result: [Rentor] = []
            rentorEntity.forEach { (item) in
                if let data = Rentor(managedObject: item) {
                    result.append(data)
                }
            }
            return result
        }.eraseToAnyPublisher()
    }
    
    internal func deleteOn(with item: Rentor) -> AnyPublisher<Void, CoreDataError> {
        guard let rentorObject = item.store(in: self.context) else {
            return AnyPublisher(Fail<Void, CoreDataError>(error: .deleteError))
        }
        return self.coreDataManager.deleteOn(with: rentorObject)
    }
}
