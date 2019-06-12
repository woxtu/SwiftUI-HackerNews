//
//  RunLoop+Extension.swift
//  HackerNews
//
//  Created by woxtu on 2019/06/13.
//  Copyright © 2019 woxtu. All rights reserved.
//

import Combine
import Foundation

extension RunLoop: Scheduler {
    public typealias SchedulerTimeType = TimeInterval
    public typealias SchedulerOptions = Never

    public var now: TimeInterval {
        Date().timeIntervalSince1970
    }

    public var minimumTolerance: Double {
        0
    }

    public func schedule(options _: Never?, _ action: @escaping () -> Void) {
        perform(action)
    }

    public func schedule(after date: TimeInterval, tolerance _: Double, options _: Never?, _ action: @escaping () -> Void) {
        let timer = Timer(fire: Date(timeIntervalSince1970: now + date), interval: 0, repeats: false, block: { _ in action() })
        add(timer, forMode: .default)
    }

    public func schedule(after date: TimeInterval, interval: TimeInterval, tolerance _: Double, options _: Never?, _ action: @escaping () -> Void) -> Cancellable {
        let timer = Timer(fire: Date(timeIntervalSince1970: now + date), interval: interval, repeats: true, block: { _ in action() })
        add(timer, forMode: .default)
        return timer
    }
}

extension Timer: Cancellable {
    public func cancel() {
        invalidate()
    }
}

extension TimeInterval: SchedulerTimeIntervalConvertible {
    public static func seconds(_ s: Int) -> TimeInterval {
        return Double(s)
    }

    public static func seconds(_ s: TimeInterval) -> TimeInterval {
        return s
    }

    public static func milliseconds(_ ms: Int) -> TimeInterval {
        return TimeInterval(ms) * 1000
    }

    public static func microseconds(_ us: Int) -> TimeInterval {
        return TimeInterval(us) * 1_000_000
    }

    public static func nanoseconds(_ ns: Int) -> TimeInterval {
        return TimeInterval(ns) * 1_000_000_000
    }
}
