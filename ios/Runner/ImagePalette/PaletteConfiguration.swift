//
//  PaletteConfiguration.swift
//  ImagePalette
//
//  Original created by Google/Android
//  Ported to Swift/iOS by Shaun Harrison
//

import Foundation
import UIKit

public struct PaletteConfiguration {
	private static let DEFAULT_CALCULATE_NUMBER_COLORS = 16
	private static let DEFAULT_RESIZE_BITMAP_MAX_DIMENSION = CGFloat(192)

	private let bitmap: UIImage?
	private let swatches: [PaletteSwatch]?

	/**
	The maximum number of colors to use in the quantization step when using an image
	as the source.

	Good values for depend on the source image type. For landscapes, good values are in
	the range 10-16. For images which are largely made up of people’s faces then this
	value should be increased to ~24.
	*/
	public var maxColors = DEFAULT_CALCULATE_NUMBER_COLORS

	/**
	Set the resize value when using an image as the source. If the bitmap’s largest
	dimension is greater than the value specified, then the image will be resized so
	that it’s largest dimension matches maxDimension. If the bitmap is smaller or
	equal, the original is used as-is.
	
	This value has a large effect on the processing time. The larger the resized image is,
	the greater time it will take to generate the palette. The smaller the image is, the
	more detail is lost in the resulting image and thus less precision for color selection.
	*/
	public var resizeMaxDimension = DEFAULT_RESIZE_BITMAP_MAX_DIMENSION

	/** Generator to use when generating the palette. If nil, the default generator will be used. */
	public var generator: PaletteGenerator?

	/**
	Create configuration using a source image
	*/
	public init(image: UIImage) {
		self.bitmap = image
		self.swatches = nil
	}

	/**
	Create configuration using an array of PaletteSwatch instances.
	Typically only used for testing.
	*/
	public init(swatches: [PaletteSwatch]) {
		assert(swatches.count > 0, "Swatches array must contain at least one swatch")

		self.bitmap = nil
		self.swatches = swatches
	}

	internal func generate() -> ([PaletteSwatch], PaletteGenerator) {
		var swatches: [PaletteSwatch]

		if let image = self.bitmap {
			// We have a Image so we need to quantization to reduce the number of colors

			assert(self.resizeMaxDimension > 0, "Minimum dimension size for resizing should should be >= 1")

			// First we’ll scale down the bitmap so it’s largest dimension is as specified
			guard let scaledBitmap = image.scaleDown(to: self.resizeMaxDimension) else {
				fatalError("Unable to scale down image.")
			}

			// Now generate a quantizer from the Bitmap
			let quantizer = ColorCutQuantizer.from(image: scaledBitmap, maxColors: self.maxColors);
			swatches = quantizer.quantizedColors
		} else if let s = self.swatches {
			// We’re using the provided swatches
			swatches = s
		} else {
			fatalError("Invalid palette configuration.")
		}

		// If we haven't been provided with a generator, use the default
		let generator: PaletteGenerator

		if let g = self.generator {
			generator = g
		} else {
			generator = DefaultPaletteGenerator()
		}

		// Now call let the Generator do it’s thing
		generator.generate(swatches: swatches)

		return (swatches, generator)
	}

}
