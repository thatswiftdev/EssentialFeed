// Created for EssentialFeed.
// Copyright © 2021. All rights reserved.

import CoreData

public final class CoreDataFeedStore: FeedStore {
  
  private static let modelName = "FeedStore"
  private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataFeedStore.self))
  
  private let container: NSPersistentContainer
  private let context: NSManagedObjectContext
  
  enum StoreError: Swift.Error {
    case modelNotFound
    case failedToLoadPersistentStore(Swift.Error)
  }
  
  public init(storeURL: URL) throws {
    
    guard let model = CoreDataFeedStore.model else {
      throw StoreError.modelNotFound
    }
    
    do {
      container = try NSPersistentContainer.load(name: CoreDataFeedStore.modelName, model: model, url: storeURL)
      context = container.newBackgroundContext()
    } catch {
      throw StoreError.failedToLoadPersistentStore(error)
    }
  }
  
  public func deleteCacheFeed(completion: @escaping DeletionCompletion) {
    let context = self.context
    
    context.perform {
      completion(Result {
        try ManagedCache.find(in: context).map(context.delete).map(context.save)
      })
    }
  }
  
  public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
    let context = self.context
    context.perform {
      completion(Result {
        let managedCache = try ManagedCache.newUniqueInstance(in: context)
        managedCache.timestamp = timestamp
        managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
        
        try context.save()
      })
    }
  }
  
  public func retrieve(completion: @escaping RetrievalCompletion) {
    let context = self.context
    
    context.perform {
      completion(Result {
        try ManagedCache.find(in: context).map {
          return CacheFeed(feed: $0.localFeed, timestamp: $0.timestamp)
        }
      })
    }
  }
  
  private func cleanUpReferencesoPersistentStores() {
    context.performAndWait {
      let coordinator = self.container.persistentStoreCoordinator
      try? coordinator.persistentStores.forEach(coordinator.remove)
    }
  }
  
  deinit {
    cleanUpReferencesoPersistentStores()
  }
}
