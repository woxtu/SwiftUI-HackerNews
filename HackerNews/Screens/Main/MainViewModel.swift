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

final class MainViewModel: ObservableObject {
    var feedType: FeedType = .top {
        didSet {
            items.removeAll()
            fetchFeed(type: feedType)
        }
    }

    var hasMoreItems: Bool {
        items.count < feed.count
    }

    @Published var items: [Item] = []

    private let perPage: Int = 12

    private var feed: [Int] = [] {
        didSet { fetchItems(ids: feed.prefix(perPage)) }
    }

    private var isLoading: Bool = false
    private var cancellers: Set<AnyCancellable> = []

    func onAppear() {
        fetchFeed(type: feedType)
    }

    func loadMoreItems() {
        fetchItems(ids: feed.dropLast(items.count).prefix(perPage))
    }

    func fetchFeed(type: FeedType) {
        HackerNewsAPI.FetchFeed(type: type)
            .sink(receiveCompletion: {
                if case let .failure(error) = $0 {
                    print(error)
                }
            }, receiveValue: {
                self.feed = $0
            })
            .store(in: &cancellers)
    }

    func fetchItems<S>(ids: S) where S: Sequence, S.Element == Int {
        if isLoading {
            return
        }
        isLoading = true

        Publishers.Sequence(sequence: ids)
            .flatMap(maxPublishers: .max(4)) { HackerNewsAPI.FetchItem(id: $0) }
            .collect()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                if case let .failure(error) = $0 {
                    print(error)
                }

                self.isLoading = false
            }, receiveValue: {
                self.items = self.items + $0
            })
            .store(in: &cancellers)
    }
}
