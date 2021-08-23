//
//  Created by Bayu on 8/23/21.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClient {
  private let session: URLSession
  
  init(session: URLSession = .shared) {
    self.session = session
  }
  
  func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
    session.dataTask(with: url) { _, _, error in
      if let error = error {
        completion(.failure(error))
      }
    }.resume()
  }
}

class URLSessionHTTPClientTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    URLProtocolStub.startInterceptingRequest()
  }
  
  override func tearDown() {
    super.tearDown()
    URLProtocolStub.stopInterceptingRequest()
  }
  
  func test_getFromURL_performsGETRequestWithURL() {
    let client = URLSessionHTTPClient()
    let url = URL(string: "https://any-url.com")!
    let exp = expectation(description: "Wait for request")
    
    URLProtocolStub.observeRequests { request in
      XCTAssertEqual(request.url, url)
      XCTAssertEqual(request.httpMethod, "GET")
      exp.fulfill()
    }
    
    client.get(from: url) { _ in }
    
    wait(for: [exp], timeout: 1.0)
  }
  
  func test_getFromURL_failsOnRequestError() {
    let url = URL(string: "https://any-url.com")!
    let error = NSError(domain: "Any Error", code: 1)
    URLProtocolStub.stub(data: nil, response: nil, error: error)
    let sut = URLSessionHTTPClient()
    
    let exp = expectation(description: "Wait for completion")
    
    sut.get(from: url) { result in
      switch result {
      case let .failure(receivedError as NSError):
        XCTAssertEqual(receivedError.domain, error.domain)
        XCTAssertEqual(receivedError.code, error.code)
      default:
        XCTFail("Expected failure with \(error), got \(result) instead.")
      }
      exp.fulfill()
    }
    
    wait(for: [exp], timeout: 1.0)
  }
  
  // MARK: - Helpers
  private class URLProtocolStub: URLProtocol {
    private static var stub: Stub?
    private static var requestObserver: ((URLRequest) -> Void)?
    
    private struct Stub {
      let data: Data?
      let response: URLResponse?
      let error: Error?
    }
    
    static func stub(data: Data?, response: URLResponse?, error: Error?) {
      stub = Stub(data: data, response: response, error: error)
    }
    
    static func observeRequests(observer: @escaping (URLRequest) -> Void) {
      requestObserver = observer
    }
    
    static func startInterceptingRequest() {
      URLProtocol.registerClass(URLProtocolStub.self)
    }
    
    static func stopInterceptingRequest() {
      URLProtocol.unregisterClass(URLProtocolStub.self)
      stub = nil
      requestObserver = nil
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
      requestObserver?(request)
      return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
      return request
    }
    
    override func startLoading() {
      guard let stub = URLProtocolStub.stub else { return }
      
      if let data = stub.data {
        client?.urlProtocol(self, didLoad: data)
      }
      
      if let response = stub.response {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      }
      
      if let error = stub.error {
        client?.urlProtocol(self, didFailWithError: error)
      }
      
      client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
  }
  
}
