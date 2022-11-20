import SwiftUI

struct CachedAsyncImage<Content, Placeholder>: View where Content: View, Placeholder: View {
    @ObservedObject private var viewModel: ViewModel
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder

    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        viewModel = .init(url: url)
        self.content = content
        self.placeholder = placeholder
    }

    var body: some View {
        if let image = viewModel.image {
            content(Image(uiImage: image))
        } else {
            placeholder()
        }
    }
}

private extension CachedAsyncImage {
    @MainActor class ViewModel: ObservableObject {
        @Published var image: UIImage?
        private let urlSession: URLSession

        init(url: URL?, urlSession: URLSession = .shared) {
            self.urlSession = urlSession
            load(url: url)
        }

        private func load(url: URL?) {
            guard let url = url else { return }
            if let cachedImage = ImageCache[url.absoluteString] {
                image = cachedImage
            } else {
                Task {
                    let (data, _) = try await urlSession.data(from: url)
                    let loadedImage = UIImage(data: data)
                    ImageCache[url.absoluteString] = loadedImage
                    image = loadedImage
                }
            }
        }
    }
}

private actor ImageCache {
    static private let cache = NSCache<NSString, UIImage>()
    static subscript(key: String) -> UIImage? {
        get { cache.object(forKey: NSString(string: key)) }
        set {
            if let newValue = newValue {
                cache.setObject(newValue, forKey: NSString(string: key))
            } else {
                cache.removeObject(forKey: NSString(string: key))
            }
        }
    }
}
