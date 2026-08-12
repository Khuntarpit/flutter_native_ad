import UIKit
import Flutter
import flutter_native_ad
import google_mobile_ads

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Register native ad factories (same IDs as Android / Dart).
    FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
      self,
      factoryId: "listTile",
      nativeAdFactory: ListTileNativeAdFactory()
    )
    FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
      self,
      factoryId: "listTileMedium",
      nativeAdFactory: MediumNativeAdFactory()
    )

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
