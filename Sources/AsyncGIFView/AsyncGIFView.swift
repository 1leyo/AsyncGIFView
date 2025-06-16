import SwiftUI

public struct AsyncGIFView<Content: View, Placeholder: View>: View {
    private let url: URL
    private let content: (GIFView) -> Content
    private let placeholder: () -> Placeholder
    
    @State private var frames: [GIFFrame]? = nil
    
    public init(
        url: URL,
        @ViewBuilder content: @escaping (GIFView) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    public var body: some View {
        Group {
            if let frames {
                content(GIFView(frames: frames))
            } else {
                placeholder()
            }
        }
        .task {
            await loadGIF()
        }
    }
    
    private func loadGIF() async {
        do {
            let result = try await GIFLoader.load(from: url)
            await MainActor.run {
                frames = result
            }
        } catch {
            await MainActor.run {
                frames = nil
            }
        }
    }
}

#Preview {
    let urlString = "https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExdDhkMmpoc2Jqdm5xeWdtajF5ZXUwYnNmNWEzZm5idjZ4ZWZzZzJqeSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/oNTQZNB67kMf5VHiCj/giphy.gif"
    let url = URL(string: urlString)!
    
    VStack {
        AsyncGIFView(url: url) { gifView in
            gifView
        } placeholder: {
            ProgressView()
        }
    }
    .padding()
}
