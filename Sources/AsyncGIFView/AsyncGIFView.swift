import SwiftUI

/// A SwiftUI view that asynchronously loads and displays a GIF from a remote URL.
///
/// You provide a placeholder view to show while the GIF is loading, and a content closure that receives the loaded `GIFView` for display.
///
/// Example usage:
/// ```swift
/// AsyncGIFView(url: gifURL) { gif in
///     gif
///         .frame(width: 200, height: 200)
/// } placeholder: {
///     ProgressView()
/// }
/// ```
///
/// - Parameters:
///     - url: The remote URL of the GIF.
///     - content: A closure that receives the loaded `GIFView` for display.
///     - placeholder: A closure that returns a view to display while the GIF is loading.
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
