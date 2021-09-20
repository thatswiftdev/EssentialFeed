// Created for EssentialFeed.
// Copyright © 2021. All rights reserved.

import Foundation

public protocol FeedStore {
  typealias DeletionCompletion = (Error?) -> Void
  typealias InsertionCompletion = (Error?) -> Void
  
  func deleteCacheFeed(completion: @escaping DeletionCompletion)
  func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
}
