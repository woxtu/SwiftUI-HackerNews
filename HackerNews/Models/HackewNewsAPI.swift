//
//  HackewNewsAPI.swift
//  HackerNews
//
//  Created by woxtu on 2019/06/13.
//  Copyright © 2019 woxtu. All rights reserved.
//

import Combine
import Foundation

class HackerNewsAPI {
    struct FetchFeed: Publisher {
        typealias Output = [Int]
        typealias Failure = Error

        let type: FeedType

        func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
            let request = URLRequest(url: URL(string: "https://hacker-news.firebaseio.com/v0/\(type.rawValue)stories.json")!)
            URLSession.DataTaskPublisher(request: request, session: URLSession.shared)
                .map(\.0)
                .decode(type: [Int].self, decoder: JSONDecoder())
                .receive(subscriber: subscriber)
        }
    }

    struct FetchItem: Publisher {
        typealias Output = Item
        typealias Failure = Error

        let id: Int

        func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970

            let request = URLRequest(url: URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json")!)
            URLSession.DataTaskPublisher(request: request, session: URLSession.shared)
                .map(\.0)
                .decode(type: Item.self, decoder: decoder)
                .receive(subscriber: subscriber)
        }
    }
}
