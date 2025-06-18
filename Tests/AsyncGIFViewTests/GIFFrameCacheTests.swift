import XCTest
@testable import AsyncGIFView

final class GIFFrameCacheTests: XCTestCase {
    func testStoreAndRetrieveGIFFrames() async {
        let cache = GIFFrameCache.shared
        
        let url = URL(string: "https://example.com/test.gif")!
        let dummyFrame = GIFFrame(frame: PlatformImage(), duration: 0.1)
        let frames = [dummyFrame]
        
        await cache.set(url, frames: frames)
        
        let result = await cache.get(url)
        
        XCTAssertNotNil(result, "Expected frames to be returned from cache")
        XCTAssertEqual(result?.count, 1, "Expected one frame to be returned")
        XCTAssertEqual(result?.first?.duration, 0.1, "Expected duration to match")
    }

    func testRetrievingUnknownURLReturnsNil() async {
        let cache = GIFFrameCache.shared
        let unknownURL = URL(string: "https://example.com/unknown.gif")!
        
        let result = await cache.get(unknownURL)
        
        XCTAssertNil(result, "Expected nil for unknown URL")
    }

    func testEvictionOfLeastRecentlyUsedFrame() async {
        let cache = GIFFrameCache.shared
        
        let dummyFrame = GIFFrame(frame: PlatformImage(), duration: 0.1)
        let frames = [dummyFrame]
        
        for i in 0..<30 {
            let url = URL(string: "https://example.com/test\(i).gif")!
            await cache.set(url, frames: frames)
        }
        
        let preservedURL = URL(string: "https://example.com/test15.gif")!
        _ = await cache.get(preservedURL)
        
        let extraURL = URL(string: "https://example.com/overflow.gif")!
        await cache.set(extraURL, frames: frames)
        
        let evictedURL = URL(string: "https://example.com/0.gif")!
        let evicted = await cache.get(evictedURL)
        XCTAssertNil(evicted, "Expected least recently used frame to be evicted")
        
        let preserved = await cache.get(preservedURL)
        XCTAssertNotNil(preserved, "Expected preserved frame to still remain in cache")
    }

    func testAccessOrderUpdatesOnGet() async {
        let cache = GIFFrameCache.shared
        
        let dummyFrame = GIFFrame(frame: PlatformImage(), duration: 0.1)
        let frames = [dummyFrame]
        
        for i in 0..<30 {
            let url = URL(string: "https://example.com/test\(i).gif")!
            await cache.set(url, frames: frames)
        }
        
        let accessedURL = URL(string: "https://example.com/test13.gif")!
        _ = await cache.get(accessedURL)
        
        let extraURL = URL(string: "https://example.com/overflow.gif")!
        await cache.set(extraURL, frames: frames)
        
        let evictedURL = URL(string: "https://example.com/test0.gif")!
        let evicted = await cache.get(evictedURL)
        XCTAssertNil(evicted, "Expected least recently used frame to be evicted")
        
        let accessed = await cache.get(accessedURL)
        XCTAssertNotNil(accessed, "Expected accessed frame to still remain in cache")
    }

    func testCacheClearingRemovesAllEntries() async {
        let cache = GIFFrameCache.shared
        
        let dummyFrame = GIFFrame(frame: PlatformImage(), duration: 0.1)
        let frames = [dummyFrame]
        let urls = (0..<5).map { URL(string: "https://example.com/test\($0).gif")! }
        
        for url in urls {
            await cache.set(url, frames: frames)
        }
        
        await cache.clear()
        
        for url in urls {
            let result = await cache.get(url)
            XCTAssertNil(result, "Expected nil for all URLs after clearing cache")
        }
    }
    
    // MARK: - Setup and Teardown
    override func setUp() async throws {
        await GIFFrameCache.shared.clear()
    }

    override func tearDown() async throws {
        await GIFFrameCache.shared.clear()
    }
}
