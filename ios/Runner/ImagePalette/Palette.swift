//
//  Palette.swift
//  ImagePalette
//
//  Original created by Google/Android
//  Ported to Swift/iOS by Shaun Harrison
//

import Foundation
import UIKit

private func createQueue() -> DispatchQueue {
	return DispatchQueue(label: "palette.generator", qos: .background, attributes: .concurrent, target: DispatchQueue.global(qos: .background))
}

public struct Palette {
	static var internalQueue = createQueue()
	
	/** All of the swatches which make up the palette */
	public let swatches: [PaletteSwatch]
	private let generator: PaletteGenerator

	private init(swatches: [PaletteSwatch], generator: PaletteGenerator) {
		self.swatches = swatches
		self.generator = generator
	}

	/**
	Create a palette synchronously.
	*/
	public init(configuration: PaletteConfiguration) {
		let (swatches, generator) = configuration.generate()
		self.init(swatches: swatches, generator: generator)
	}

	public static func generateWith(configuration: PaletteConfiguration, completion: @escaping (Palette) -> Void) {
		self.generateWith(configuration: configuration, queue: self.internalQueue, completion: completion)
	}

	public static func generateWith(configuration: PaletteConfiguration, queue: DispatchQueue, completion: @escaping (Palette) -> Void) {
		queue.async {
			let (swatches, generator) = configuration.generate()
			let palette = self.init(swatches: swatches, generator: generator)

			DispatchQueue.main.async {
				completion(palette)
			}
		}
	}

	/** The most vibrant swatch in the palette. */
	public var vibrantSwatch: PaletteSwatch? {
		return self.generator.vibrantSwatch
	}

	/** Light and vibrant swatch from the palette. */
	public var lightVibrantSwatch: PaletteSwatch? {
		return self.generator.lightVibrantSwatch
	}

	/** Dark and vibrant swatch from the palette. */
	public var darkVibrantSwatch: PaletteSwatch? {
		return self.generator.darkVibrantSwatch
	}

	/** Muted swatch from the palette. */
	public var mutedSwatch: PaletteSwatch? {
		return self.generator.mutedSwatch
	}

	/** Muted and light swatch from the palette. */
	public var lightMutedSwatch: PaletteSwatch? {
		return self.generator.lightMutedSwatch
	}

	/** Muted and dark swatch from the palette. */
	public var darkMutedSwatch: PaletteSwatch? {
		return self.generator.darkMutedSwatch
	}

	/**
	Returns the most vibrant color in the palette as an RGB packed int.

	:param: defaultColor value to return if the swatch isn't available
	*/
	public func vibrantColor(defaultColor: UIColor) -> UIColor {
		return self.vibrantSwatch?.color ?? defaultColor
	}

	/**
	Returns a light and vibrant color from the palette as an RGB packed int.

	:param: defaultColor value to return if the swatch isn't available
	*/
	public func lightVibrantColor(defaultColor: UIColor) -> UIColor {
		return self.lightVibrantSwatch?.color ?? defaultColor
	}

	/**
	Returns a dark and vibrant color from the palette as an RGB packed int.

	:param: defaultColor value to return if the swatch isn't available
	*/
	public func darkVibrantColor(defaultColor: UIColor) -> UIColor {
		return self.darkVibrantSwatch?.color ?? defaultColor
	}

	/**
	Returns a muted color from the palette as an RGB packed int.

	:param: defaultColor value to return if the swatch isn't available
	*/
	public func mutedColor(defaultColor: UIColor) -> UIColor {
		return self.mutedSwatch?.color ?? defaultColor
	}

	/**
	Returns a muted and light color from the palette as an RGB packed int.

	:param: defaultColor value to return if the swatch isn't available
	*/
	public func lightMutedColor(defaultColor: UIColor) -> UIColor {
		return self.lightMutedSwatch?.color ?? defaultColor
	}

	/**
	Returns a muted and dark color from the palette as an RGB packed int.

	:param: defaultColor value to return if the swatch isn't available
	*/
	public func darkMutedColor(defaultColor: UIColor) -> UIColor {
		return self.darkMutedSwatch?.color ?? defaultColor
	}

}
