import Foundation
import ImageIO

final class GIFLoader {
    static func load(from url: URL) async throws -> [GIFFrame] {
        if let cached = await GIFFrameCache.shared.get(url) { return cached }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw NSError(
                domain: "GIFLoader",
                code: http.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "Bad response: \(http.statusCode)"]
            )
        }
        
        guard let frames = decode(data: data) else {
            throw NSError(domain: "GIFLoader", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid GIF data"])
        }
        
        await GIFFrameCache.shared.set(url, frames: frames)
        
        return frames
    }
    
    private static func decode(data: Data) -> [GIFFrame]? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        
        let count = CGImageSourceGetCount(source)
        var frames: [GIFFrame] = []
        
        for i in 0..<count {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else { continue }
            
#if os(iOS) || os(tvOS)
            let image = PlatformImage(cgImage: cgImage)
#elseif os(macOS)
            let image = PlatformImage(cgImage: cgImage, size: .zero)
#endif
            
            let delay = frameDuration(at: i, source: source)
            frames.append(GIFFrame(frame: image, duration: delay))
        }
        
        return frames
    }
    
    private static func frameDuration(at index: Int, source: CGImageSource) -> TimeInterval {
        guard
            let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any],
            let gifDict = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any]
        else {
            return 0.1
        }
        
        return
            gifDict[kCGImagePropertyGIFUnclampedDelayTime] as? TimeInterval ??
            gifDict[kCGImagePropertyGIFDelayTime] as? TimeInterval ??
            0.1
    }
}
