// Created for EssentialFeed.
// Copyright © 2021. All rights reserved.

import Foundation

public typealias CacheFeed = (feed: [LocalFeedImage], timestamp: Date)

public protocol FeedStore {
  
  typealias DeletionResult = Error?
  typealias DeletionCompletion = (DeletionResult) -> Void
  
  typealias InsertionResult = Error?
  typealias InsertionCompletion = (DeletionResult) -> Void
  
  typealias RetrievalResult = Swift.Result<CacheFeed?, Error>
  typealias RetrievalCompletion = (RetrievalResult) -> Void
  
  /// The completion handler can be invoked in any thread.
  /// Clients are responsible to dispatch to appropriate threads, if needed.
  func deleteCacheFeed(completion: @escaping DeletionCompletion)
  
  /// The completion handler can be invoked in any thread.
  /// Clients are responsible to dispatch to appropriate threads, if needed.
  func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
  
  /// The completion handler can be invoked in any thread.
  /// Clients are responsible to dispatch to appropriate threads, if needed.
  func retrieve(completion: @escaping RetrievalCompletion)
}
