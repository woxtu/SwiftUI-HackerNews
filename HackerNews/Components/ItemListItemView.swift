//
//  ItemListItemView.swift
//  HackerNews
//
//  Created by woxtu on 2019/06/09.
//  Copyright (c) 2019 woxtu. All rights reserved.
//

import SwiftUI

struct ItemListItemView: View {
    let item: Item

    func format(date: Date) -> String {
        struct Static {
            static let dateFormatter = DateFormatter(dateStyle: .short, timeStyle: .short)
        }

        return Static.dateFormatter.string(from: date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // cannot use if-let statement?
            if item.title != nil {
                Text(item.title!).font(.headline)
            }
            if item.text != nil {
                Text(item.text!).font(.subheadline)
            }
            HStack {
                Text("\(item.score) pts | \(item.by) | \(format(date: item.time)) | \(item.kids.count)")
                    .color(.gray)
                Spacer()
            }
        }
        .padding([.top, .bottom], 4)
    }
}
