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
                    ForEach(FeedType.allCases.identified(by: \.self)) { type in
                        Text(type.rawValue.capitalized)
                    }
                }
                .padding([.leading, .trailing], 16)
                if !viewModel.items.isEmpty {
                    List {
                        ForEach(viewModel.items.identified(by: \.id)) { item in
                            ItemListItemView(item: item)
                        }
                        if viewModel.hasMoreStories {
                            Button(action: { self.viewModel.loadMoreStories.send(()) }) {
                                Text("Load more")
                                    .color(Color("Primary"))
                            }
                        }
                    }
                } else {
                    Spacer()
                }
            }
            .navigationBarTitle(Text("Hacker News"))
        }
    }
}
