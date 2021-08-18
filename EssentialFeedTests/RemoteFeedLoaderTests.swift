//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Bayu Kurniawan on 8/18/21.
//

import XCTest

class RemoteFeedLoader {
  
}

class HTTPClient {
  var requestedURL: URL?
}
class RemoteFeedLoaderTests: XCTestCase {

  func test_init_doesNotRequestsDataFromURL() {
    
    let client = HTTPClient()
    _ = RemoteFeedLoader()
  
    XCTAssertNil(client.requestedURL)
  }

}
