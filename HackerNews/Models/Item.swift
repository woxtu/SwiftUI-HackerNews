//
//  Item.swift
//  HackerNews
//
//  Created by woxtu on 2019/06/09.
//  Copyright © 2019 woxtu. All rights reserved.
//

import Foundation

struct Item {
    let by: String
    let id: Int
    let kids: [Int]
    let score: Int
    let time: Date
    let title: String?
    let text: String?
    let url: String?

    var webURL: URL? {
        URL(string: "https://news.ycombinator.com/item?id=\(id)")
    }
}

extension Item: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        by = try container.decode(String.self, forKey: .by)
        id = try container.decode(Int.self, forKey: .id)
        kids = try container.decodeIfPresent([Int].self, forKey: .kids) ?? []
        score = try container.decode(Int.self, forKey: .score)
        time = Date(timeIntervalSince1970: TimeInterval(try container.decode(Int.self, forKey: .time)))
        title = try container.decodeIfPresent(String.self, forKey: .title)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        url = try container.decodeIfPresent(String.self, forKey: .url)
    }
}
