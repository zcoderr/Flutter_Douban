//
//  UIImage+PaletteExtension.swift
//  ImagePalette
//
//  Original created by Google/Android
//  Ported to Swift/iOS by Shaun Harrison
//

import Foundation
import UIKit

extension UIImage {

	/**
	Scale the image down so that it’s largest dimension is targetMaxDimension.
	If image is smaller than this, then it is returned.
	*/
	internal func scaleDown(to targetMaxDimension: CGFloat) -> UIImage? {
		let size = self.size
		let maxDimensionInPoints = max(size.width, size.height)
		let maxDimensionInPixels = maxDimensionInPoints * self.scale

		if maxDimensionInPixels <= targetMaxDimension {
			// If the bitmap is small enough already, just return it
			return self
		}

		let scaleRatio = targetMaxDimension / maxDimensionInPoints
		let width = round(size.width * scaleRatio)
		let height = round(size.height * scaleRatio)

		UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), true, 1.0)
		self.draw(in: CGRect(x: 0.0, y: 0.0, width: width, height: height))
		let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return scaledImage
	}

	internal var pixels: [Int64] {
		let image = self.cgImage!

		let pixelsWide = image.width
		let pixelsHigh = image.height

		let bitmapBytesPerRow = (pixelsWide * 4)
		let bitmapByteCount = (bitmapBytesPerRow * pixelsHigh)

		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapData = malloc(bitmapByteCount)
		defer { free(bitmapData) }

		guard let context = CGContext(data: bitmapData, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) else {
			fatalError("Unable to create bitmap context")
		}

		guard let unconstrainedData = context.data else {
			fatalError("Unable to get bitmap data")
		}

		context.draw(image, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(pixelsWide), height: CGFloat(pixelsHigh)))

		let data = unconstrainedData.bindMemory(to: UInt8.self, capacity: pixelsWide * pixelsHigh)
		var pixels = [Int64]()

		for x in 0 ..< pixelsWide {
			for y in 0 ..< pixelsHigh {
				let pixelInfo = ((pixelsWide * y) + x) * 4

				let alpha = Int64(data[pixelInfo])
				let red = Int64(data[pixelInfo + 1])
				let green = Int64(data[pixelInfo + 2])
				let blue = Int64(data[pixelInfo + 3])

				pixels.append(HexColor.fromARGB(alpha, red: red, green: green, blue: blue))
			}
		}

		return pixels
	}

}
