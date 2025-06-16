#if DEBUG
@inline(__always)
func GIFCacheLog(_ msg: @autoclosure () -> String) {
    print("[AsyncGIF] \(msg())")
}
#else
@inline(__always)
func GIFCacheLog(_: @autoclosure () -> String) {}
#endif
