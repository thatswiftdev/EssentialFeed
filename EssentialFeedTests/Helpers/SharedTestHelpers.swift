// Created for EssentialFeed.
// Copyright © 2021. All rights reserved.

import Foundation

func anyNSError() -> NSError {
  return NSError(domain: "Any Error", code: 0)
}

func anyURL() -> URL {
  return URL(string: "https://any-url.com")!
}
