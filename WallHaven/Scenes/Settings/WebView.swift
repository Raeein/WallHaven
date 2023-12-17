import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {

        let prefs: WKWebpagePreferences = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true

        let config: WKWebViewConfiguration = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs

        return WKWebView(frame: .zero, configuration: config)
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
