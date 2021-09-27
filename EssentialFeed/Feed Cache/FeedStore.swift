// Created for EssentialFeed.
// Copyright © 2021. All rights reserved.

import Foundation

public enum RetrieveCacheFeedResult {
  case empty
  case found(feed: [LocalFeedImage], timestamp: Date)
  case failure(Error)
}


public protocol FeedStore {
  typealias DeletionCompletion = (Error?) -> Void
  typealias InsertionCompletion = (Error?) -> Void
  typealias RetrievalCompletion = (RetrieveCacheFeedResult) -> Void
  
  func deleteCacheFeed(completion: @escaping DeletionCompletion)
  func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
  func retrieve(completion: @escaping RetrievalCompletion)
}
