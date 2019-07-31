//
//  MainViewModel.swift
//  HackerNews
//
//  Created by woxtu on 2019/06/13.
//  Copyright © 2019 woxtu. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

final class MainViewModel: BindableObject {
    let willChange = PassthroughSubject<MainViewModel, Never>()

    var feedType = FeedType.top {
        didSet {
            items.removeAll()
            fetchFeed(type: feedType)
        }
    }

    var hasMoreItems: Bool {
        items.count < feed.count
    }

    var items = [Item]() {
        willSet { willChange.send(self) }
    }

    private let perPage = 12

    private var feed = [Int]() {
        didSet { fetchItems(ids: feed.prefix(perPage)) }
    }

    private var isLoading = false
    private var subscriber: Cancellable?

    deinit {
        subscriber?.cancel()
    }

    func onAppear() {
        fetchFeed(type: feedType)
    }

    func loadMoreItems() {
        fetchItems(ids: feed.dropLast(items.count).prefix(perPage))
    }

    func fetchFeed(type: FeedType) {
        if isLoading {
            return
        }
        isLoading = true

        subscriber = HackerNewsAPI.FetchFeed(type: type)
            .sink(receiveCompletion: {
                if case let .failure(error) = $0 {
                    print(error)
                }
            }, receiveValue: {
                self.isLoading = false
                self.feed = $0
            })
    }

    func fetchItems<S>(ids: S) where S: Sequence, S.Element == Int {
        if isLoading {
            return
        }
        isLoading = true

        subscriber = Publishers.MergeMany(ids.map { HackerNewsAPI.FetchItem(id: $0) })
            .collect()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                if case let .failure(error) = $0 {
                    print(error)
                }
            }, receiveValue: {
                self.isLoading = false
                self.items = self.items + $0
            })
    }
}
