import SwiftUI

public struct GIFView: View {
    let frames: [GIFFrame]
    
    @State private var currentIndex: Int = 0
    @State private var timer: Timer?
    
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
