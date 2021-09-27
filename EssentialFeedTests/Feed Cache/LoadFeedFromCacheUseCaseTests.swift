// Created for EssentialFeed.
// Copyright © 2021. All rights reserved.

import XCTest
import EssentialFeed

class LoadFeedFromCacheUseCaseTests: XCTestCase {
  
  func test_init_doesNotMessageStoreUponCreation() {
    let (_, store) = makeSUT()
    
    XCTAssertEqual(store.receivedMessages, [])
  }
  
  func test_load_requestsCacheRetrieval() {
    let (sut, store) = makeSUT()
    
    sut.load { _ in }
    
    XCTAssertEqual(store.receivedMessages, [.retrieve])
  }
  
  func test_load_failsOnRetrievalError() {
    let (sut, store) = makeSUT()
    let retrievalError = anyNSError()
    let exp = expectation(description: "Wait for load completion")
   
    sut.load { result in
      switch result {
      case let .failure(error):
        XCTAssertEqual(error as NSError?, retrievalError)
      default:
        XCTFail("Expected error got \(result) instead")
      }
      exp.fulfill()
    }
    
    store.completeRetrieval(with: retrievalError)
    wait(for: [exp], timeout: 1.0)
  }
  
  func test_load_deliversNoImagesOnemptyCache() {
    let (sut, store) = makeSUT()
    let exp = expectation(description: "Wait for load completion")

    sut.load { result in
      switch result {
      case let .success(images):
          XCTAssertEqual(images, [])
      default:
        XCTFail("Expected succes, got \(result) instead.")
      }
      exp.fulfill()
    }

    store.completeRetrievalWithEmptyCache()
    wait(for: [exp], timeout: 1.0)
  }
  
  // MARK: -  Helpers
  private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
    let store = FeedStoreSpy()
    let sut = LocalFeedLoader(store: store, currentDate: currentDate)
    trackForMemoryLeaks(store, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, store)
  }
  
  private func anyNSError() -> NSError {
    return NSError(domain: "Any Error", code: 0)
  }
}
