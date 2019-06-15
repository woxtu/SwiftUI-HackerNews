//
//  DispatchQueue+Extension.swift
//  HackerNews
//
//  Created by woxtu on 2019/06/15.
//  Copyright © 2019 woxtu. All rights reserved.
//

import Combine
import Foundation

extension DispatchQueue: Scheduler {
    public var now: DispatchTime {
        .now()
    }

    public var minimumTolerance: Double {
        0
    }

    public func schedule(options _: Never?, _ action: @escaping () -> Void) {
        async(execute: action)
    }

    public func schedule(after date: DispatchTime, tolerance _: Double, options _: Never?, _ action: @escaping () -> Void) {
        asyncAfter(deadline: date, execute: action)
    }

    public func schedule(after date: DispatchTime, interval: Double, tolerance _: Double, options _: Never?, _ action: @escaping () -> Void) -> Cancellable {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: self)
        timer.schedule(deadline: date, repeating: interval)
        timer.setEventHandler(handler: action)
        timer.resume()
        return Canceller(source: timer)
    }

    private struct Canceller: Cancellable {
        let source: DispatchSourceProtocol

        func cancel() {
            source.cancel()
        }
    }
}

extension DispatchTime: Strideable {
    public func advanced(by n: Double) -> DispatchTime {
        return self + n
    }

    public func distance(to other: DispatchTime) -> Double {
        return Double((uptimeNanoseconds - other.uptimeNanoseconds) / 1_000_000_000)
    }
}

extension Double: SchedulerTimeIntervalConvertible {
    public static func seconds(_ s: Int) -> Self {
        return Self(s)
    }

    public static func seconds(_ s: Double) -> Self {
        return s
    }

    public static func milliseconds(_ ms: Int) -> Self {
        return Self(ms * 1000)
    }

    public static func microseconds(_ us: Int) -> Self {
        return Self(us * 1_000_000)
    }

    public static func nanoseconds(_ ns: Int) -> Self {
        return Self(ns * 1_000_000_000)
    }
}
