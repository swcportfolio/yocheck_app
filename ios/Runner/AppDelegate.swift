import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      
      let controller = window?.rootViewController as! FlutterViewController
      
      let channelStore = FlutterMethodChannel(name: "com.wonpl.urine/appstore", binaryMessenger: controller.binaryMessenger)
      
      let channelShop = FlutterMethodChannel(name: "com.wonpl.urine/shop", binaryMessenger: controller.binaryMessenger)
      
      channelStore.setMethodCallHandler { (call, result) in
           if call.method == "openAppStore" {
             if let url = URL(string: "https://apps.apple.com/app/id6478642650") {
               if UIApplication.shared.canOpenURL(url) {
                 UIApplication.shared.open(url)
                 result("App Store opened")
               } else {
                 result(FlutterError(code: "UNAVAILABLE", message: "Cannot open App Store URL", details: nil))
               }
             } else {
               result(FlutterError(code: "INVALID_URL", message: "Invalid URL", details: nil))
             }
           } else {
             result(FlutterMethodNotImplemented)
           }
         }
      
      channelShop.setMethodCallHandler { (call, result) in
        if call.method == "openShop" {
          if let url = URL(string: "http://www.optosta.com/shop/list.php?ca_id=20") {
            if UIApplication.shared.canOpenURL(url) {
              UIApplication.shared.open(url)
              result("optosta shop opened")
            } else {
              result(FlutterError(code: "UNAVAILABLE", message: "Cannot open Shop URL", details: nil))
            }
          } else {
            result(FlutterError(code: "INVALID_URL", message: "Invalid URL", details: nil))
          }
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
      
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
