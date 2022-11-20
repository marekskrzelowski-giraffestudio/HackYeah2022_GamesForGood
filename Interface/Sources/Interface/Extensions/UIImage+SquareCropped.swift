import UIKit

extension UIImage {
    var squareCropped: Self? {
        guard let cgImage = cgImage else { return nil }
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let cropSize = min(width, height)
        let cropRect = CGRect(
            x: (width - cropSize) / 2,
            y: (height - cropSize) / 2,
            width: cropSize,
            height: cropSize
        )
        if let imageRef = cgImage.cropping(to: cropRect) {
            return Self(cgImage: imageRef, scale: 0, orientation: imageOrientation)
        } else {
            return nil
        }
    }
}
