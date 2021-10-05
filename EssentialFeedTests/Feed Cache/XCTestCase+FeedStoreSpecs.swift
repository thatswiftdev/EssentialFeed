// Created for EssentialFeed.
// Copyright © 2021. All rights reserved.

import XCTest
import EssentialFeed

extension FeedStoreSpecs where Self: XCTestCase {
  @discardableResult
  func deleteCache(from sut: FeedStore) -> Error? {
    let exp = expectation(description: "Wait for cache deletion.")
    var deletionError: Error?
    
    sut.deleteCacheFeed { receivedDeletionError in
      deletionError = receivedDeletionError
      exp.fulfill()
    }
    wait(for: [exp], timeout: 6.0)
    
    return deletionError
  }
  
  @discardableResult
  func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStore) -> Error? {
    let exp = expectation(description: "Wait for cache insertion")
    
    var capturedError: Error?
    sut.insert(cache.feed, timestamp: cache.timestamp) { insertionError in
      capturedError = insertionError
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1.0)
    return capturedError
  }
  
  func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: RetrieveCacheFeedResult, file: StaticString = #filePath, line: UInt = #line) {
    expect(sut, toRetrieve: expectedResult, file: file, line: line)
    expect(sut, toRetrieve: expectedResult, file: file, line: line)
  }
  
  func expect(_ sut: FeedStore, toRetrieve expectedResult: RetrieveCacheFeedResult, file: StaticString = #filePath, line: UInt = #line) {
    let exp = expectation(description: "Wait for cache retrieval")
    
    sut.retrieve { retrievedResult in
      switch (expectedResult, retrievedResult) {
      case (.empty, .empty),
        (.failure, .failure):
        break
        
      case let (.found(expectedFeed, expectedTimestamp), .found(retrievedFeed, retrievedTimestamp)):
        XCTAssertEqual(expectedFeed, retrievedFeed, file: file, line: line)
        XCTAssertEqual(expectedTimestamp, retrievedTimestamp, file: file, line: line)
        
      default:
        XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
      }
      
      exp.fulfill()
    }
    
    wait(for: [exp], timeout: 1.0)
  }
}
