// Created for EssentialFeed.
// Copyright © 2021. All rights reserved.

import XCTest
import EssentialFeed

class EssentialFeedCacheIntegrationTests: XCTestCase {
  
  func test_load_deliversNoItemsOnEmptyCache() {
    let sut = makeSUT()
    
    let exp = expectation(description: "Wait for load completion")
    sut.load { result in
      switch result {
      case let .success(feedImage):
        XCTAssertEqual(feedImage, [], "Expected empty feed image.")
      
      case let .failure(error):
        XCTFail("Expected empty feed image, got \(error) instead.")
      }
      
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1.0)
  }
  
  // MARK: -  Helpers
  private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalFeedLoader {
    let storeBundle = Bundle(for: CoreDataFeedStore.self)
    let storeURL = testSpecificStoreURL()
    let store = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
    let sut = LocalFeedLoader(store: store, currentDate: Date.init)
    trackForMemoryLeaks(store, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return sut
  }
  
  private func testSpecificStoreURL() -> URL {
    return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
  }
  
  private func cachesDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  }

}
