//
//  HSL.swift
//  ImagePalette
//
//  Original created by Google/Android
//  Ported to Swift/iOS by Shaun Harrison
//

import Foundation
import UIKit

internal struct HSLColor {
	let hue: CGFloat
	let saturation: CGFloat
	let lightness: CGFloat
	let alpha: CGFloat

	init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) {
		self.hue = hue
		self.saturation = saturation
		self.lightness = lightness
		self.alpha = alpha
	}

	var color: UIColor {
		return self.rgb.color
	}

	var rgb: RGBColor {
		let c = (1.0 - abs(2 * self.lightness - 1.0)) * self.saturation
		let m = self.lightness - 0.5 * c
		let x = c * (1.0 - abs(((self.hue / 60.0).truncatingRemainder(dividingBy: 2.0)) - 1.0))

		let hueSegment = Int(self.hue / 60.0)

		var r = Int64(0)
		var g = Int64(0)
		var b = Int64(0)

		switch hueSegment {
			case 0:
				r = Int64(round(255 * (c + m)))
				g = Int64(round(255 * (x + m)))
				b = Int64(round(255 * m))
			case 1:
				r = Int64(round(255 * (x + m)))
				g = Int64(round(255 * (c + m)))
				b = Int64(round(255 * m))
			case 2:
				r = Int64(round(255 * m))
				g = Int64(round(255 * (c + m)))
				b = Int64(round(255 * (x + m)))
			case 3:
				r = Int64(round(255 * m))
				g = Int64(round(255 * (x + m)))
				b = Int64(round(255 * (c + m)))
			case 4:
				r = Int64(round(255 * (x + m)))
				g = Int64(round(255 * m))
				b = Int64(round(255 * (c + m)))
			case 5, 6:
				r = Int64(round(255 * (c + m)))
				g = Int64(round(255 * m))
				b = Int64(round(255 * (x + m)))
			default:
				break
		}

		r = max(0, min(255, r))
		g = max(0, min(255, g))
		b = max(0, min(255, b))

		return RGBColor(red: r, green: g, blue: b, alpha: Int64(round(self.alpha * 255)))
	}

	internal func colorWith(lightness: CGFloat) -> HSLColor {
		return HSLColor(hue: self.hue, saturation: self.saturation, lightness: self.lightness, alpha: self.alpha)
	}

}
