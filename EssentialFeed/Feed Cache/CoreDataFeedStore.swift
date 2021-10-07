// Created for EssentialFeed.
// Copyright © 2021. All rights reserved.

import Foundation

public final class CoreDataFeedStore: FeedStore {
  
  public init() {}
  
  public func deleteCacheFeed(completion: @escaping DeletionCompletion) {
   
  }
  
  public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
    
  }
  
  public func retrieve(completion: @escaping RetrievalCompletion) {
    completion(.empty)
  }
}
