//
//  ActivityIndicatorView.swift
//  HackerNews
//
//  Created by woxtu on 2019/06/21.
//  Copyright © 2019 woxtu. All rights reserved.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    let style: UIActivityIndicatorView.Style
    let color: UIColor

    func makeUIView(context: Context) -> UIStackView {
        let activityIndicatorView = UIActivityIndicatorView(style: style)
        activityIndicatorView.color = color
        activityIndicatorView.startAnimating()
        return UIStackView(arrangedSubviews: [activityIndicatorView])
    }

    func updateUIView(_ uiView: UIStackView, context: Context) {}
}
