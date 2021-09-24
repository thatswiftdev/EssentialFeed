// Created for EssentialFeed.
// Copyright © 2021. All rights reserved.

import Foundation

public protocol FeedStore {
  typealias DeletionCompletion = (Error?) -> Void
  typealias InsertionCompletion = (Error?) -> Void
  typealias RetrievalCompletion = (Error?) -> Void
  
  func deleteCacheFeed(completion: @escaping DeletionCompletion)
  func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
  func retrieve(completion: @escaping RetrievalCompletion)
}
