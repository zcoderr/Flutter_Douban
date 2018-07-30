import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

class PaletteLib {
  static const MethodChannel _channel =
      const MethodChannel('channel:com.postmuseapp.designer/palette');

  static Future<dynamic> getPalette(String path) async {
    Map<dynamic, dynamic> result =
        await _channel.invokeMethod('getPalette', {'path': path});
    return Palette.fromJson(result);
  }

  static Future<dynamic> getPaletteWithByte(ByteData image) async {
    Map<dynamic, dynamic> result =
        await _channel.invokeMethod('getPaletteWihtByte', {'iamge': image});
    return Palette.fromJson(result);
  }

  static Future<dynamic> getPaletteWithUrl(String url) async {
    Map<dynamic, dynamic> result =
        await _channel.invokeMethod('getPaletteWithUrl', {'url': url});
    return Palette.fromJson(result);
  }

  static Future<dynamic> getPP() async {
    Map<dynamic, dynamic> result = await _channel.invokeMethod('getPP');
    return PP.fromJson(result);
  }
}

class PP {
  final String result;

  PP.fromJson(Map<dynamic, dynamic> map) : result = map['result'];

  Map<String, dynamic> toJson() => {'result': result};
}

class Palette {
  final PaletteSwatch vibrant,
      darkVibrant,
      lightVibrant,
      muted,
      darkMuted,
      lightMuted;
  final List<PaletteSwatch> swatches;

  Palette.fromJson(Map<dynamic, dynamic> map)
      : vibrant = map['vibrant'] == null
            ? null
            : new PaletteSwatch.fromJson(map['vibrant']),
        darkVibrant = map['darkVibrant'] == null
            ? null
            : new PaletteSwatch.fromJson(map['darkVibrant']),
        lightVibrant = map['lightVibrant'] == null
            ? null
            : new PaletteSwatch.fromJson(map['lightVibrant']),
        muted = map['muted'] == null
            ? null
            : new PaletteSwatch.fromJson(map['muted']),
        darkMuted = map['darkMuted'] == null
            ? null
            : new PaletteSwatch.fromJson(map['darkMuted']),
        lightMuted = map['lightMuted'] == null
            ? null
            : new PaletteSwatch.fromJson(map['lightMuted']),
        swatches = map['swatches'] == null
            ? null
            : (map['swatches'] as List<dynamic>)
                .map((json) => new PaletteSwatch.fromJson(json))
                .toList(growable: false);

  Map<String, dynamic> toJson() => {
        "vibrant": vibrant == null ? null : vibrant.toJson(),
        "darkVibrant": darkVibrant == null ? null : darkVibrant.toJson(),
        "lightVibrant": lightVibrant == null ? null : lightVibrant.toJson(),
        "muted": muted == null ? null : muted.toJson(),
        "darkMuted": darkMuted == null ? null : darkMuted.toJson(),
        "lightMuted": lightMuted == null ? null : lightMuted.toJson(),
        "swatches": swatches == null
            ? null
            : swatches.map((swatch) => swatch.toJson()).toList(growable: false),
      };

  @override
  String toString() {
    return 'Palette{\n'
        ' vibrant: $vibrant, \n'
        ' darkVibrant: $darkVibrant, \n'
        ' lightVibrant: $lightVibrant, \n'
        ' muted: $muted, \n'
        ' darkMuted: $darkMuted, \n'
        ' lightMuted: $lightMuted\n'
        ' swatches(${swatches.length}): $swatches\n'
        '}';
  }
}

class PaletteSwatch {
  final Color color, titleTextColor, bodyTextColor;
  final int population;

  const PaletteSwatch(
      {this.color, this.titleTextColor, this.bodyTextColor, this.population});

  PaletteSwatch.fromJson(Map<dynamic, dynamic> map)
      : color = map['color'] == null ? null : new Color(map['color']),
        titleTextColor = map['titleTextColor'] == null
            ? null
            : new Color(map['titleTextColor']),
        bodyTextColor = map['bodyTextColor'] == null
            ? null
            : new Color(map['bodyTextColor']),
        population = map['population'];

  Map<String, dynamic> toJson() => {
        "color": color == null ? null : color.value,
        "titleTextColor": titleTextColor == null ? null : titleTextColor.value,
        "bodyTextColor": bodyTextColor == null ? null : bodyTextColor.value,
        "population": population,
      };

  @override
  String toString() {
    return 'PaletteSwatch{color: $color, titleTextColor: $titleTextColor, bodyTextColor: $bodyTextColor, population: $population}';
  }
}
