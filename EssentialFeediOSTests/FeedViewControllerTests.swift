// Created for EssentialFeed.
// Copyright © 2021. All rights reserved.

import XCTest

final class FeedViewController {
  init(loader: FeedViewControllerTests.LoaderSpy) {
    
  }
}

class FeedViewControllerTests: XCTestCase {
  func test_init_doesNotLoadFeed() {
    let loader = LoaderSpy()
    _ = FeedViewController(loader: loader)
    
    XCTAssertEqual(loader.loadCallCount, 0)
  }
  
  // MARK: -  Helpers
  class LoaderSpy {
    private(set) var loadCallCount = 0
  }

}
