//
//  YTView.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-03-06.
//

import SwiftUI
import WebKit

struct YTView: View {
    let ID: String
    var body: some View {
        Video(videoID: ID)
            .frame(height: 190)
    }
}

#Preview {
    YTView(ID: "")
}

struct Video: UIViewRepresentable {
    let videoID: String

    func makeUIView(context: Context) -> some WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let YouTubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)")else {return}
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: YouTubeURL))
    }
}

