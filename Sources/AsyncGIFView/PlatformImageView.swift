import SwiftUI

#if os(iOS) || os(tvOS)
import UIKit

struct PlatformImageView: View {
    let image: PlatformImage

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
    }
}

#elseif os(macOS)
import AppKit

struct PlatformImageView: View {
    let image: PlatformImage

    var body: some View {
        Image(nsImage: image)
            .resizable()
            .scaledToFit()
    }
}
#endif
