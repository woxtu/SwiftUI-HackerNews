//
//  MainView.swift
//  HackerNews
//
//  Created by woxtu on 2019/06/09.
//  Copyright © 2019 woxtu. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        NavigationView {
            VStack {
                Picker("Feed", selection: $viewModel.feedType) {
                    ForEach(FeedType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding([.leading, .trailing], 16)
                if !viewModel.items.isEmpty {
                    List {
                        ForEach(viewModel.items, id: \.id) { item in
                            if let webURL = item.webURL {
                                NavigationLink(destination: WebView(url: webURL)
                                    .navigationBarTitle(Text(item.title ?? "Hacker News"))) {
                                        ItemListItemView(item: item)
                                    }
                            }
                        }
                        if viewModel.hasMoreItems {
                            ActivityIndicatorView(style: .medium, color: UIColor(named: "Primary")!)
                                .onAppear { self.viewModel.loadMoreItems() }
                        }
                    }
                    .listStyle(PlainListStyle())
                } else {
                    Spacer()
                }
            }
            .navigationBarTitle(Text("Hacker News"))
        }
        .onAppear { self.viewModel.onAppear() }
    }
}
