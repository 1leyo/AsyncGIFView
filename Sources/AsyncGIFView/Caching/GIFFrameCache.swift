import Foundation

actor GIFFrameCache {
    static let shared = GIFFrameCache()
    private var store: [URL: [GIFFrame]] = [:]
    private var accessOrder: [URL] = []
    
    private let maxSize: Int = 30
    
    func get(_ url: URL) -> [GIFFrame]? {
        if let frames = store[url] {
            GIFCacheLog("✅ HIT: \(url)")
            updateAccess(for: url)
            return frames
        }
        
        GIFCacheLog("❌ MISS: \(url)")
        return nil
    }
    
    func set(_ url: URL, frames: [GIFFrame]) {
        store[url] = frames
        updateAccess(for: url)
        
        if store.count > maxSize {
            removeLeastRecentlyUsed()
        }
        
        GIFCacheLog("✅ STORED: \(url) with \(frames.count) frames")
    }
    
    func clear() {
        store.removeAll()
    }
    
    private func updateAccess(for url: URL) {
        accessOrder.removeAll { $0 == url }
        accessOrder.insert(url, at: 0)
    }
    
    private func removeLeastRecentlyUsed() {
        guard let leastUsed = accessOrder.popLast() else { return }
        store.removeValue(forKey: leastUsed)
        GIFCacheLog("🗑️ Removed least recently used: \(leastUsed)")
    }
}
