//
//  URLSession+Extension.swift
//  HackerNews
//
//  Created by woxtu on 2019/06/13.
//  Copyright © 2019 woxtu. All rights reserved.
//

import Combine
import Foundation

extension URLSession {
    struct Publisher: Combine.Publisher {
        typealias Output = Data
        typealias Failure = Error

        let session: URLSession
        let url: URL

        func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
            // TODO: improve error handling
            let task = session.dataTask(with: url) { data, _, error in
                if let data = data {
                    _ = subscriber.receive(data)
                    subscriber.receive(completion: .finished)
                } else if let error = error {
                    subscriber.receive(completion: .failure(error))
                } else {
                    subscriber.receive(completion: .failure(UnknownError()))
                }
            }

            let subscription = URLSessionDataTask.Subscription(task: task)
            subscriber.receive(subscription: subscription)

            task.resume()
        }
    }

    struct UnknownError: LocalizedError {
        var localizedDescription = "Something happened"
    }
}

extension URLSessionDataTask {
    struct Subscription: Combine.Subscription {
        let combineIdentifier = CombineIdentifier()
        let task: URLSessionTask

        func request(_: Subscribers.Demand) {}

        func cancel() {
            task.cancel()
        }
    }
}
