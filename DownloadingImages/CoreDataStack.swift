//
//  CoreDataStack.swift
//  DownloadingImages
//
//  Created by Jim Campagno on 1/18/17.
//  Copyright © 2017 Jim Campagno. All rights reserved.
//

import Foundation
import CoreData


final class CoreDataStack {
    
    static let shared = CoreDataStack()
    var tempStore: NSPersistentStore!
    var mainStore: NSPersistentStore!
    private static let name = "DownloadingImages"
    
    
    private init() { }
    
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: name)
        
        self.tempStore = try! container.persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        for store in container.persistentStoreCoordinator.persistentStores {
            if let metadata = store.metadata, let storeType = metadata["NSStoreType"] as? String {
                if storeType == "SQLite" {
                    self.mainStore = store
                    break
                }
            }
        }
        
        return container
    }()
    
    func addMovieToTempStorage(_ movie: Movie) {
        context.assign(movie, to: tempStore)
    }
    
    func addMovieToMainStorage(_ movie: Movie) -> Movie {
        let json = movie.serialize()
        context.delete(movie)
        let newFilm = Movie(json: json, tempStorage: false)
        context.assign(newFilm, to: mainStore)
        return newFilm
    }
    
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                print("attempt to save the context.")
                try context.save()
            } catch {
                // TODO: Handle possible error instead of just crashing.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
