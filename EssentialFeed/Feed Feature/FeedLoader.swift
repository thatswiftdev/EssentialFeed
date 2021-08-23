//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Bayu Kurniawan on 8/18/21.
//

import Foundation

public enum LoadFeedResult {
  case success([FeedItem])
  case failure(Error)
}

public protocol FeedLoader {
  func load(completion: @escaping (LoadFeedResult) -> Void)
}
