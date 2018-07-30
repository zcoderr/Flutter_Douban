//
//  DefaultGenerator.swift
//  ImagePalette
//
//  Original created by Google/Android
//  Ported to Swift/iOS by Shaun Harrison
//

import Foundation
import UIKit

private let TARGET_DARK_LUMA = CGFloat(0.26)
private let MAX_DARK_LUMA = CGFloat(0.45)

private let MIN_LIGHT_LUMA = CGFloat(0.55)
private let TARGET_LIGHT_LUMA = CGFloat(0.74)

private let MIN_NORMAL_LUMA = CGFloat(0.3)
private let TARGET_NORMAL_LUMA = CGFloat(0.5)
private let MAX_NORMAL_LUMA = CGFloat(0.7)

private let TARGET_MUTED_SATURATION = CGFloat(0.3)
private let MAX_MUTED_SATURATION = CGFloat(0.4)

private let TARGET_VIBRANT_SATURATION = CGFloat(1)
private let MIN_VIBRANT_SATURATION = CGFloat(0.35)

private let WEIGHT_SATURATION = CGFloat(3.0)
private let WEIGHT_LUMA = CGFloat(6.0)
private let WEIGHT_POPULATION = CGFloat(1.0)

internal class DefaultPaletteGenerator: PaletteGenerator {

	private var swatches = [PaletteSwatch]()
	private var highestPopulation = Int64(0)

	private(set) var vibrantSwatch: PaletteSwatch?
	private(set) var lightVibrantSwatch: PaletteSwatch?
	private(set) var darkVibrantSwatch: PaletteSwatch?
	private(set) var mutedSwatch: PaletteSwatch?
	private(set) var lightMutedSwatch: PaletteSwatch?
	private(set) var darkMutedSwatch: PaletteSwatch?

	func generate(swatches: [PaletteSwatch]) {
		self.swatches = swatches

		self.highestPopulation = findMaxPopulation()

		self.generateVariationColors()

		// Now try and generate any missing colors
		self.generateEmptySwatches()
	}

	private func generateVariationColors() {
		self.vibrantSwatch = self.findColorVariation(targetLuma: TARGET_NORMAL_LUMA, minLuma: MIN_NORMAL_LUMA, maxLuma: MAX_NORMAL_LUMA, targetSaturation: TARGET_VIBRANT_SATURATION, minSaturation: MIN_VIBRANT_SATURATION, maxSaturation: 1.0)
		self.lightVibrantSwatch = self.findColorVariation(targetLuma: TARGET_LIGHT_LUMA, minLuma: MIN_LIGHT_LUMA, maxLuma: 1.0, targetSaturation: TARGET_VIBRANT_SATURATION, minSaturation: MIN_VIBRANT_SATURATION, maxSaturation: 1.0)
		self.darkVibrantSwatch = self.findColorVariation(targetLuma: TARGET_DARK_LUMA, minLuma: 0.0, maxLuma: MAX_DARK_LUMA, targetSaturation: TARGET_VIBRANT_SATURATION, minSaturation: MIN_VIBRANT_SATURATION, maxSaturation: 1.0)
		self.mutedSwatch = self.findColorVariation(targetLuma: TARGET_NORMAL_LUMA, minLuma: MIN_NORMAL_LUMA, maxLuma: MAX_NORMAL_LUMA, targetSaturation: TARGET_MUTED_SATURATION, minSaturation: 0.0, maxSaturation: MAX_MUTED_SATURATION)
		self.lightMutedSwatch = self.findColorVariation(targetLuma: TARGET_LIGHT_LUMA, minLuma: MIN_LIGHT_LUMA, maxLuma: 1.0, targetSaturation: TARGET_MUTED_SATURATION, minSaturation: 0.0, maxSaturation: MAX_MUTED_SATURATION)
		self.darkMutedSwatch = self.findColorVariation(targetLuma: TARGET_DARK_LUMA, minLuma: 0.0, maxLuma: MAX_DARK_LUMA, targetSaturation: TARGET_MUTED_SATURATION, minSaturation: 0.0, maxSaturation: MAX_MUTED_SATURATION)
	}

	/** Try and generate any missing swatches from the swatches we did find. */
	private func generateEmptySwatches() {
		if self.vibrantSwatch == nil {
			// If we do not have a vibrant color...
			if let swatch = self.darkVibrantSwatch {
				// ...but we do have a dark vibrant, generate the value by modifying the luma
				self.vibrantSwatch = PaletteSwatch(color: swatch.hsl.colorWith(lightness: TARGET_NORMAL_LUMA), population: 0)
			}
		}

		if self.darkVibrantSwatch == nil {
			// If we do not have a dark vibrant color...
			if let swatch = self.vibrantSwatch {
				// ...but we do have a vibrant, generate the value by modifying the luma
				self.darkVibrantSwatch = PaletteSwatch(color: swatch.hsl.colorWith(lightness: TARGET_DARK_LUMA), population: 0)
			}
		}
	}

	/** Find the PaletteSwatch with the highest population value and return the population. */
	private func findMaxPopulation() -> Int64 {
		var population = Int64(0)

		for swatch in self.swatches {
			population = max(population, swatch.population)
		}

		return population
	}

	private func findColorVariation(targetLuma: CGFloat, minLuma: CGFloat, maxLuma: CGFloat, targetSaturation: CGFloat, minSaturation: CGFloat, maxSaturation: CGFloat) -> PaletteSwatch? {
		var max: PaletteSwatch? = nil
		var maxValue = 0.0

		for swatch in self.swatches {
			let sat = swatch.hsl.saturation
			let luma = swatch.hsl.lightness

			guard sat >= minSaturation && sat <= maxSaturation && luma >= minLuma && luma <= maxLuma && !isAlreadySelected(swatch: swatch) else {
				continue
			}

			let value = Double(type(of: self).createComparisonValue(saturation: sat, targetSaturation: targetSaturation, luma: luma, targetLuma: targetLuma, population: swatch.population, maxPopulation: self.highestPopulation))

			guard max == nil || value > maxValue else {
				continue
			}

			max = swatch
			maxValue = value
		}

		return max
	}

	/**
	:return: true if we have already selected PaletteSwatch
	*/
	private func isAlreadySelected(swatch: PaletteSwatch) -> Bool {
		return self.vibrantSwatch == swatch || self.darkVibrantSwatch == swatch || self.lightVibrantSwatch == swatch || self.mutedSwatch == swatch || self.darkMutedSwatch == swatch || self.lightMutedSwatch == swatch
	}

	private static func createComparisonValue(saturation: CGFloat, targetSaturation: CGFloat, luma: CGFloat, targetLuma: CGFloat, population: Int64, maxPopulation: Int64) -> CGFloat {
		return self.createComparisonValue(saturation: saturation, targetSaturation: targetSaturation, saturationWeight: WEIGHT_SATURATION, luma: luma, targetLuma: targetLuma, lumaWeight: WEIGHT_LUMA, population: population, maxPopulation: maxPopulation, populationWeight: WEIGHT_POPULATION)
	}

	private static func createComparisonValue(saturation: CGFloat, targetSaturation: CGFloat, saturationWeight: CGFloat, luma: CGFloat, targetLuma: CGFloat, lumaWeight: CGFloat, population: Int64, maxPopulation: Int64, populationWeight: CGFloat) -> CGFloat {
		return weightedMean(values: [
			invertDiff(value: saturation, targetValue: targetSaturation), saturationWeight,
			invertDiff(value: luma, targetValue: targetLuma), lumaWeight,
			CGFloat(population) / CGFloat(maxPopulation), populationWeight
		])
	}

	/**
	Returns a value in the range 0-1. 1 is returned when value equals the targetValue and then decreases as the
	absolute difference between value and {@code targetValue} increases.

	:param: value the item’s value
	:param: targetValue the value which we desire
	*/
	private static func invertDiff(value: CGFloat, targetValue: CGFloat) -> CGFloat {
		return 1.0 - abs(value - targetValue)
	}

	private static func weightedMean(values: [CGFloat]) -> CGFloat {
		var sum = CGFloat(0)
		var sumWeight = CGFloat(0)

		for i in stride(from: 0, to: values.count - 1, by: 2) {
			let value = values[i]
			let weight = values[i + 1]
			
			sum += (value * weight)
			sumWeight += weight
		}
		
		return sum / sumWeight
	}
	
}
