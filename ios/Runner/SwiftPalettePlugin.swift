import Flutter
import UIKit

let PALETTE_CHANNEL = "channel:com.postmuseapp.designer/palette";

public class SwiftPalettePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: PALETTE_CHANNEL, binaryMessenger: registrar.messenger())
        let instance = SwiftPalettePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let path = arguments["path"] as? String
        let url = arguments["url"] as? String
        if ("getPalette" == call.method){
            self.getPalette(path: path!, result:result)
        }else if("getPaletteWithUrl"==call.method){
            self.getPaletteWithUrl(url: url!, result: result)
        }
    }
    
    func getPalette(path:String, result:@escaping FlutterResult){
        getPalette(path: path, result: result, onPalette: {palette in
            result(self.convertPalette(palette: palette))
        })
    }
    
    func getPaletteWithUrl(url:String,result:@escaping FlutterResult){
        getPaletteWithUrl(url: url, result: result,onPalette: {palette in
            result(self.convertPalette(palette: palette))
        })
    }
    
    func getPalette(path:String, result:FlutterResult, onPalette:@escaping (Palette)->Void){
        do {
            let imageUrl = URL.init(fileURLWithPath: path)
            let imageData = try Data.init(contentsOf: imageUrl)
            let image = UIImage.init(data: imageData)!
            Palette.generateWith(configuration: PaletteConfiguration(image: image)) {palette in
                onPalette(palette)
            }
        } catch {
            print(error)
            result(error)
        }
    }
    
    func getPaletteWithUrl(url:String,result:FlutterResult,onPalette:@escaping(Palette)->Void){
        do{
            let imgUrl = URL.init(string: url)
            let uiImage = try UIImage.init(data: Data.init(contentsOf: imgUrl!))
            Palette.generateWith(configuration: PaletteConfiguration(image: uiImage!)) {palette in
                onPalette(palette)
            }
        }catch{
            print(error)
            result(error)
        }
    
    }
    
    func convertPalette(palette: Palette) -> Dictionary<String, Any> {
        var paletteMap = Dictionary<String, Any>()
        paletteMap["vibrant"] = convertSwatch(swatch:palette.vibrantSwatch)
        paletteMap["darkVibrant"] = convertSwatch(swatch:palette.darkVibrantSwatch)
        paletteMap["lightVibrant"] = convertSwatch(swatch:palette.lightVibrantSwatch)
        paletteMap["muted"] = convertSwatch(swatch:palette.mutedSwatch)
        paletteMap["darkMuted"] = convertSwatch(swatch:palette.darkMutedSwatch)
        paletteMap["lightMuted"] = convertSwatch(swatch:palette.lightMutedSwatch)
        paletteMap["swatches"] = palette.swatches.map{convertSwatch(swatch: $0)}
        return paletteMap;
    }
    
    func convertSwatch(swatch: PaletteSwatch?) -> Dictionary<String, Any>? {
        if (swatch != nil){
            let swatch = swatch!
            var swatchMap = Dictionary<String, Any>()
            swatchMap["color"] = colorToARGB(color: swatch.color)
            swatchMap["population"] = swatch.population
            swatchMap["titleTextColor"] = colorToARGB(color: swatch.titleTextColor)
            swatchMap["bodyTextColor"] = colorToARGB(color: swatch.bodyTextColor)
            swatchMap["swatchInfo"] = swatch.debugDescription
            return swatchMap;
        } else {
            return nil
        }
    }
    
    func colorToARGB(color: UIColor?) -> Int?{
        if (color == nil){
            return nil
        }
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        color!.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = Int(round(red * 255.0))
        let g = Int(round(green * 255.0))
        let b = Int(round(blue * 255.0))
        let a = Int(round(alpha * 255.0))
        
        return (a << 24) | (r << 16) | (g << 8) | b
    }
}
