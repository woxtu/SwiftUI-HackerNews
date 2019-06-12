//
//  DateFormatter+Extension.swift
//  HackerNews
//
//  Created by woxtu on 2019/06/09.
//  Copyright © 2019 woxtu. All rights reserved.
//

import Foundation

extension DateFormatter {
    convenience init(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) {
        self.init()
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
    }
}
