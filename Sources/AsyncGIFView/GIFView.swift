import SwiftUI

/// A SwiftUI view that displays a GIF using an already decoded animated GIF _(a sequence of frames)_.
///
/// This view is not typically used directly by clients.. It is provided to you inside the `content` closure of the `AsyncGIFView` when you load a GIF from a remote URL.
///
/// - Note: The GIF animation starts when the view appears and stops when it disappears.
/// - Note: Additional functionality like pause/resume is planned for future versions.
public struct GIFView: View {
    let frames: [GIFFrame]
    
    @State private var currentIndex: Int = 0
    @State private var timer: Timer?
    
    /// Creates a GIFView with decoded frames.
    ///
    /// - Parameter frames: An array of `GIFFrame` values representing each image and its duration.
    public init(frames: [GIFFrame]) {
        self.frames = frames
    }
    
    public var body: some View {
        PlatformImageView(image: frames[currentIndex].frame)
            .onAppear(perform: startAnimating)
            .onDisappear(perform: stopAnimating)
    }
    
    private func startAnimating() {
        stopAnimating()

        guard frames.count > 1 else { return }

        scheduleNextFrame()
    }

    private func scheduleNextFrame() {
        timer = Timer.scheduledTimer(withTimeInterval: frames[currentIndex].duration, repeats: false) { _ in
            DispatchQueue.main.async {
                advanceFrame()
            }
        }
    }

    private func advanceFrame() {
        currentIndex = (currentIndex + 1) % frames.count
        scheduleNextFrame()
    }
    
    private func stopAnimating() {
        timer?.invalidate()
        timer = nil
    }
}
