//
//  ActivityIndicatorView.swift
//  HackerNews
//
//  Created by woxtu on 2019/06/21.
//  Copyright © 2019 woxtu. All rights reserved.
//

import SwiftUI

struct ActivityIndicatorView: View {
    let style: UIActivityIndicatorView.Style
    let color: UIColor
    @State private var size: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            InnerView(style: self.style, color: self.color, parentSize: geometry.size, size: self.$size)
        }
        .frame(height: size.height)
    }

    struct InnerView: UIViewRepresentable {
        let style: UIActivityIndicatorView.Style
        let color: UIColor
        let parentSize: CGSize
        @Binding var size: CGSize

        func makeUIView(context: Context) -> UIActivityIndicatorView {
            let uiView = UIActivityIndicatorView(style: style)
            uiView.color = color
            uiView.startAnimating()
            return uiView
        }

        func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
            DispatchQueue.main.async {
                self.size = uiView.sizeThatFits(self.parentSize)
            }
        }
    }
}
