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

    var items = [Item]() {
        didSet { didChange.send(self) }
    }

    private let perPage = 12

    private var feed = [Int]() {
        didSet { fetchItems(ids: feed.prefix(perPage)) }
    }

    private var cancellable: Cancellable?

    init() {
        fetchFeed(type: feedType)
    }

    func fetchFeed(type: FeedType) {
        cancellable = HackerNewsAPI.FetchFeed(type: type)
            .replaceError(with: [])
            .assign(to: \.feed, on: self)
    }

    func fetchItems<S>(ids: S) where S: Sequence, S.Element == Int {
        cancellable = Publishers.MergeMany(ids.map(HackerNewsAPI.FetchItem.init))
            .collect()
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .assign(to: \.items, on: self)
    }
}
