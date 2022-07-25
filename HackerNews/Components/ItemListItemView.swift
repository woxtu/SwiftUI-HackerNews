//
//  ItemListItemView.swift
//  HackerNews
//
//  Created by woxtu on 2019/06/09.
//  Copyright © 2019 woxtu. All rights reserved.
//

import SwiftUI

struct ItemListItemView: View {
    let item: Item

    private static let dateFormatter: DateFormatter = .init(dateStyle: .short, timeStyle: .short)

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if let title = item.title {
                Text(title)
                    .font(.headline)
                    .lineLimit(nil)
            } else if let text = item.text {
                Text(text)
                    .font(.subheadline)
                    .lineLimit(nil)
            }
            HStack {
                Text("by \(item.by) \(item.time, formatter: Self.dateFormatter)")
                    .foregroundColor(.gray)
                Image(systemName: "hand.thumbsup")
                    .foregroundColor(.gray)
                    .imageScale(.small)
                Text("\(item.score)")
                    .foregroundColor(.gray)
                Image(systemName: "bubble.right")
                    .foregroundColor(.gray)
                    .imageScale(.small)
                Text("\(item.kids.count)")
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .padding([.top, .bottom], 4)
    }
}
