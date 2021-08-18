//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Bayu Kurniawan on 8/18/21.
//

import Foundation

enum LoadFeedResult {
  case success([FeedItem])
  case error(Error)
}

protocol FeedLoader {
  func load(completion: @escaping (LoadFeedResult) -> Void)
}
