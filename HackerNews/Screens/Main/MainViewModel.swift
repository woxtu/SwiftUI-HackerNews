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
    let didChange = PassthroughSubject<MainViewModel, Never>()

    var feedType = FeedType.top {
        didSet {
            items.removeAll()
            fetchFeed(type: feedType)
        }
    }

    let viewDidAppear = PassthroughSubject<Void, Never>()
    let loadMoreStories = PassthroughSubject<Void, Never>()

    var hasMoreStories: Bool {
        items.count < feed.count
    }

    var items = [Item]() {
        didSet { didChange.send(self) }
    }

    private let perPage = 12

    private var feed = [Int]() {
        didSet { fetchItems(ids: feed.prefix(perPage)) }
    }

    private var isLoading = false
    private var task: Cancellable?

    init() {
        _ = viewDidAppear
            .sink { _ in self.fetchFeed(type: self.feedType) }

        _ = loadMoreStories
            .sink { _ in self.fetchItems(ids: self.feed.dropLast(self.items.count).prefix(self.perPage)) }
    }

    deinit {
        task?.cancel()
    }

    func fetchFeed(type: FeedType) {
        if isLoading {
            return
        }
        isLoading = true

        task = HackerNewsAPI.FetchFeed(type: type)
            .sink {
                self.isLoading = false
                self.feed = $0
            }
    }

    func fetchItems<S>(ids: S) where S: Sequence, S.Element == Int {
        if isLoading {
            return
        }
        isLoading = true

        task = Publishers.MergeMany(ids.map { HackerNewsAPI.FetchItem(id: $0) })
            .collect()
            .receive(on: DispatchQueue.main)
            .sink {
                self.isLoading = false
                self.items = self.items + $0
            }
    }
}
