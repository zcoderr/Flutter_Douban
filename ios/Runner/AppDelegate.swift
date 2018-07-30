import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    SwiftPalettePlugin.register(with:registrar(forPlugin: "channel:com.postmuseapp.designer/palette"))
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
