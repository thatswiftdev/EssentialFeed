// Created for EssentialFeed.
// Copyright © 2021. All rights reserved.

import Foundation
import EssentialFeed

internal class FeedStoreSpy: FeedStore {
  
  enum ReceivedMessage: Equatable {
    case deleteCacheFeed
    case insert([LocalFeedImage], Date)
    case retrieve
  }
  
  private var deletionCompletions = [DeletionCompletion]()
  private var insertionCompletions = [InsertionCompletion]()
  private var retrievalCompletions = [RetrievalCompletion]()
  private(set) var receivedMessages = [ReceivedMessage]()
  
  func deleteCacheFeed(completion: @escaping DeletionCompletion) {
    deletionCompletions.append(completion)
    receivedMessages.append(.deleteCacheFeed)
  }
  
  func completeDeletion(with error: Error, at index: Int = 0) {
    deletionCompletions[index](.failure(error))
  }
  
  func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
    insertionCompletions.append(completion)
    receivedMessages.append(.insert(feed, timestamp))
  }
  
  func completeDeletionSuccessfully(at index: Int = 0) {
    deletionCompletions[index](.success(()))
  }
  
  func completeInsertion(with error: Error, at index: Int = 0) {
    insertionCompletions[index](.failure(error))
  }
  
  func completeInsertionSuccessfully(at index: Int = 0) {
    insertionCompletions[index](.success(()))
  }
  
  func retrieve(completion: @escaping RetrievalCompletion) {
    retrievalCompletions.append(completion)
    receivedMessages.append(.retrieve)
  }
  
  func completeRetrieval(with error: Error, at index: Int = 0) {
    retrievalCompletions[index](.failure(error))
  }
  
  func completeRetrievalWithEmptyCache(at index: Int = 0) {
    retrievalCompletions[index](.success(.none))
  }
  
  func completeRetrieval(with feed: [LocalFeedImage], timestamp: Date, at index: Int = 0) {
    retrievalCompletions[index](.success(CacheFeed(feed: feed, timestamp: timestamp)))
  }
}
