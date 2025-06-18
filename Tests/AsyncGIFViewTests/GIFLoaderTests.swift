import XCTest
@testable import AsyncGIFView

final class GIFLoaderTests: XCTestCase {
    func testLoadValidGIF() async throws {
        let urlString = "https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif"
        let url = URL(string: urlString)!
        
        let frames = try await GIFLoader.load(from: url)
        
        XCTAssertFalse(frames.isEmpty, "Expected non-empty frames for valid GIF")
        XCTAssertGreaterThan(frames.first!.duration, 0.0, "Expected frame duration to be greater than 0.0")
    }
    
    func testLoadInvalidGIF() async throws {
        let url = URL(string: "https://example.com/invalidOrNonExisting.gif")!
        
        do {
            _ = try await GIFLoader.load(from: url)
            XCTFail("Expected to throw an error for invalid GIF")
        } catch {
            // Pass: Error is expected for invalid GIF
        }
    }
}

