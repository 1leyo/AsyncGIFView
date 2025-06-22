# AsyncGIFView

[![Version](https://img.shields.io/github/v/tag/1leyo/AsyncGIFView?label=version)](https://github.com/1leyo/AsyncGIFView/releases)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)
![Swift](https://img.shields.io/badge/swift-6.0-orange)

A lightweight Swift Package to load and render animated GIFs asynchronously in SwiftUI on macOS and iOS.

## ✨ Features

- 🔁 Asynchronous GIF loading via URL
- 🧠 In-memory LRU cache to optimize performance
- 🧱 Declarative SwiftUI API
- 🖼️ Works out-of-the-box with placeholder support
- 🍎 Supports iOS & macOS

## 🚀 Installation

Add the package to your project via **Swift Package Manager**:
```
https://github.com/1leyo/AsyncGIFView
```

### 📦 Using Package.swift

If you want to use `Package.swift` directly, simply add it to the `dependencies` section:
```swift
dependencies: [
    .package(url: "https://github.com/1leyo/AsyncGIFView.git", from: "0.0.1")
]
```

## 🧪 Example Usage

```swift
AsyncGIFView(url: gifURL) { gif in
    gif
        .frame(width: 200, height: 200)
} placeholder: {
    ProgressView()
}
```

## 📦 API Overview

### `AsyncGIFView`

```swift
AsyncGIFView(
    url: URL,
    content: (GIFView) -> Content,
    placeholder: () -> Placeholder
)
```

- **url**: Remote URL of the GIF
- **content**: Closure providing the rendered GIFView
- **placeholder**: Closure for the loading placeholder

### `GIFView`

A view that plays pre-decoded frames. Used internally and passed to you by `AsyncGIFView`.

**Note**: This view will be fully available in the future, allowing loading GIFs from the asset catalog or local files.

## 🧹 Limitations

- Only supports remote GIFs at the moment
- No playback controls _(e.g. pause/resume)_ yet

## 🧪 Tests

Run the test suite using:

```bash
swift test
```

## 🔮 Roadmap

- [ ] Local GIF loading (from bundle)
- [ ] Pause / resume / loop count
- [ ] Performance tuning for large GIFs

## 🙌 Credits & Motivation

Developed as a reusable component for currently unreleased projects of mine. I hope it can be useful for others as well!

Developed and maintained by [1leyo](https://leyo.dev) with ❤️ from Bavaria, Germany.
