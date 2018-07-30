//
//  ColorHistogram.swift
//  ImagePalette
//
//  Original created by Google/Android
//  Ported to Swift/iOS by Shaun Harrison
//

import Foundation
import UIKit

/**
Class which provides a histogram for RGB values.
*/
public struct ColorHistogram {

	/**
	An array containing all of the distinct colors in the image.
	*/
	private(set) public var colors = [Int64]()

	/**
	An array containing the frequency of a distinct colors within the image.
	*/
	private(set) public var colorCounts = [Int64]()

	/**
	Number of distinct colors in the image.
	*/
	private(set) public var numberOfColors: Int

	/**
	A new ColorHistogram instance.

	:param: Pixels array of image contents
	*/
	public init(pixels: [Int64]) {
		// Sort the pixels to enable counting below
		var pixels = pixels
		pixels.sort()

		// Count number of distinct colors
		self.numberOfColors = type(of: self).countDistinctColors(pixels)

		// Finally count the frequency of each color
		self.countFrequencies(pixels)
	}

	private static func countDistinctColors(_ pixels: [Int64]) -> Int {
		if pixels.count < 2 {
			// If we have less than 2 pixels we can stop here
			return pixels.count
		}

		// If we have at least 2 pixels, we have a minimum of 1 color...
		var colorCount = 1
		var currentColor = pixels[0]

		// Now iterate from the second pixel to the end, counting distinct colors
		for pixel in pixels {
			// If we encounter a new color, increase the population
			if pixel != currentColor {
				currentColor = pixel
				colorCount += 1
			}
		}

		return colorCount
	}

	private mutating func countFrequencies(_ pixels: [Int64]) {
		if pixels.count == 0 {
			return
		}

		var currentColorIndex = 0
		var currentColor = pixels[0]

		self.colors.append(currentColor)
		self.colorCounts.append(1)

		if pixels.count == 1 {
			// If we only have one pixel, we can stop here
			return
		}

		// Now iterate from the second pixel to the end, population distinct colors
		for pixel in pixels {
			if pixel == currentColor {
				// We’ve hit the same color as before, increase population
				self.colorCounts[currentColorIndex] += 1
			} else {
				// We’ve hit a new color, increase index
				currentColor = pixel

				currentColorIndex += 1
				self.colors.append(currentColor)
				self.colorCounts.append(1)
			}
		}
	}
	
}
