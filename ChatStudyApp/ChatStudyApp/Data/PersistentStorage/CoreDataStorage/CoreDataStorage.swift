//
//  CoreDataStorage.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/11/22.
//

import CoreData

enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

final class CoreDataStorage {
    
    static let shared = CoreDataStorage()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    // MARK: Internal
    
    func save(
        entityName: String,
        values: [String: Any]) throws
    {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            throw CoreDataStorageError.saveError(
                NSError(
                    domain: "SaveError",
                    code: 0))
        }
        
        let manageObject = NSManagedObject(entity: entityDescription, insertInto: context)
        values.forEach { (key, value) in
            manageObject.setValue(value, forKey: key)
        }
        
        do {
            try saveContext()
        } catch {
            throw CoreDataStorageError.saveError(error)
        }
    }
    
    // TODO: 나머지 fetch, delete에 대한 구현은 진행하지않았음. - 호출시기를 파악하고 그것을 다시 구현할 것
}

extension CoreDataStorage {
    private func saveContext() throws {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw CoreDataStorageError.saveError(error)
            }
        }
    }
}
