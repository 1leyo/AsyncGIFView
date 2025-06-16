import Foundation

actor GIFFrameCache {
    static let shared = GIFFrameCache()
    private var store: [URL: [GIFFrame]] = [:]
    
    func get(_ url: URL) -> [GIFFrame]? { store[url] }
    func set(_ url: URL, frames: [GIFFrame]) { store[url] = frames }
    func clear() { store.removeAll() }
}
