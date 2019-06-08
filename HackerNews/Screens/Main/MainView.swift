//
//  MainView.swift
//  HackerNews
//
//  Created by woxtu on 2019/06/09.
//  Copyright (c) 2019 woxtu. All rights reserved.
//

import SwiftUI

struct MainView: View {
    enum FeedType: String, CaseIterable {
        case top = "Top"
        case new = "New"
        case show = "Show"
        case ask = "Ask"
    }

    @State var feedType = FeedType.top

    var items = [Item](repeating: Item.dummy, count: 20)

    var body: some View {
        NavigationView {
            VStack {
                SegmentedControl(selection: $feedType) {
                    ForEach(FeedType.allCases.identified(by: \.self)) { type in
                        Text(type.rawValue)
                    }
                }
                .padding([.leading, .trailing], 16)
                List {
                    ForEach(items.identified(by: \.id)) { item in
                        ItemListItemView(item: item)
                    }
                }
            }
            .navigationBarTitle(Text("Hacker News"))
        }
    }
}
