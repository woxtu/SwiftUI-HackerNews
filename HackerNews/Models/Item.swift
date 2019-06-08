//
//  Item.swift
//  HackerNews
//
//  Created by woxtu on 2019/06/09.
//  Copyright (c) 2019 woxtu. All rights reserved.
//

import Foundation

struct Item {
    let by: String
    let descendants: Int
    let id: Int
    let kids: [Int]
    let score: Int
    let time: Date
    let title: String?
    let text: String?
    let type: String
    let url: String
}

extension Item {
    static var dummy = Item(by: "dhouston",
                            descendants: 71,
                            id: 8863,
                            kids: [],
                            score: 111,
                            time: Date(timeIntervalSince1970: 1_175_714_200),
                            title: "My YC app: Dropbox - Throw away your USB drive",
                            text: nil,
                            type: "story",
                            url: "http://www.getdropbox.com/u/2/screencast.html")
}
