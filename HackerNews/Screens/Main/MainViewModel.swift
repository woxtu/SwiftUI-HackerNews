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

    private var task: Cancellable?

    init() {
        _ = loadMoreStories
            .throttle(for: 3.0, scheduler: DispatchQueue.global(), latest: false)
            .sink { _ in
                self.fetchItems(ids: self.feed.dropLast(self.items.count).prefix(self.perPage))
            }

        fetchFeed(type: feedType)
    }

    deinit {
        task?.cancel()
    }

    func fetchFeed(type: FeedType) {
        task = HackerNewsAPI.FetchFeed(type: type)
            .replaceError(with: [])
            .assign(to: \.feed, on: self)
    }

    func fetchItems<S>(ids: S) where S: Sequence, S.Element == Int {
        task = Publishers.MergeMany(ids.map { HackerNewsAPI.FetchItem(id: $0) })
            .collect()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .map { self.items + $0 }
            .assign(to: \.items, on: self)
    }
}
