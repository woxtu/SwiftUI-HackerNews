//
//  MainView.swift
//  HackerNews
//
//  Created by woxtu on 2019/06/09.
//  Copyright © 2019 woxtu. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @ObjectBinding var viewModel: MainViewModel

    var body: some View {
        NavigationView {
            VStack {
                SegmentedControl(selection: $viewModel.feedType) {
                    ForEach(FeedType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized)
                    }
                }
                .padding([.leading, .trailing], 16)
                if !viewModel.items.isEmpty {
                    List {
                        ForEach(viewModel.items, id: \.id) { item in
                            NavigationLink(destination: WebView(url: URL(string: item.htmlUrl)!)
                                .navigationBarTitle(Text(item.title ?? "Hacker News"))) {
                                ItemListItemView(item: item)
                            }
                        }
                        if viewModel.hasMoreItems {
                            ActivityIndicatorView(style: .medium, color: UIColor(named: "Primary")!)
                                .onAppear { self.viewModel.loadMoreItems() }
                        }
                    }
                } else {
                    Spacer()
                }
            }
            .navigationBarTitle(Text("Hacker News"))
        }
        .onAppear { self.viewModel.onAppear() }
    }
}
