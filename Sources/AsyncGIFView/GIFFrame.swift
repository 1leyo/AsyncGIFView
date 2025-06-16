import Foundation

#if os(iOS)
import UIKit
public typealias PlatformImage = UIImage
#elseif os(macOS)
import AppKit
public typealias PlatformImage = NSImage
#endif

public struct GIFFrame: @unchecked Sendable {
    let frame: PlatformImage
    let duration: TimeInterval
    
    public init(frame: PlatformImage, duration: TimeInterval) {
        self.frame = frame
        self.duration = duration
    }
}
