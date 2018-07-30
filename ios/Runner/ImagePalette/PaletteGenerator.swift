//
//  PaletteGenerator.swift
//  ImagePalette
//
//  Original created by Google/Android
//  Ported to Swift/iOS by Shaun Harrison
//

/**
Protocol for Palette which allows custom processing of the list of
PaletteSwatch instances which represent an image.

You should do as much processing as possible during the
generate method call. The other methods in this class
may be called multiple times to retrieve an appropriate PaletteSwatch.
*/
public protocol PaletteGenerator {

	/**
	This method will be called with the PaletteSwatch that represent an image.
	You should process this list so that you have appropriate values when the other methods in
	class are called.

	This method will probably be called on a background thread.
	*/
	func generate(swatches: [PaletteSwatch])

	/** Return the most vibrant PaletteSwatch */
	var vibrantSwatch: PaletteSwatch? { get }

	/** A light and vibrant PaletteSwatch */
	var lightVibrantSwatch: PaletteSwatch? { get }

	/** A dark and vibrant PaletteSwatch */
	var darkVibrantSwatch: PaletteSwatch? { get }

	/** A muted PaletteSwatch */
	var mutedSwatch: PaletteSwatch? { get }

	/** A muted and light PaletteSwatch */
	var lightMutedSwatch: PaletteSwatch? { get }

	/** A muted and dark PaletteSwatch */
	var darkMutedSwatch: PaletteSwatch? { get }

}
