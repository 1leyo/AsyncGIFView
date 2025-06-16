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
        .task(id: url) {
            frames = nil
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
    let urlString = "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExdGl0aXJtaXZiN2I0dTA2cTVtY3FyaXdtNW5vZTZxbWFyN2hlenJnOSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/thNsW0HZ534DC/giphy.gif"
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
