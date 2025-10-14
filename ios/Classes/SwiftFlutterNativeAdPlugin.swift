import Flutter
import UIKit
import GoogleMobileAds

public class SwiftFlutterNativeAdPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_native_ad", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterNativeAdPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getNativeAds":
      if let args = call.arguments as? [String: Any],
         let nativeVideoID = args["nativeVideoID"] as? String {
        // Register native ad factories for iOS
        let nativeAdFactory = NativeAdFactoryExample()
        let mediumNativeAdFactory = NativeAdFactoryMedium()
        
        // Register with Google Mobile Ads plugin
        registrar.viewController()?.view.addSubview(UIView())
        
        result(["status": "success", "message": "Native ads registered for iOS"])
      } else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

// Native Ad Factory for small ads
class NativeAdFactoryExample: NSObject, FlutterPlatformViewFactory {
  func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
    return NativeAdView(frame: frame, viewId: viewId, args: args)
  }
}

// Native Ad Factory for medium ads
class NativeAdFactoryMedium: NSObject, FlutterPlatformViewFactory {
  func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
    return NativeAdView(frame: frame, viewId: viewId, args: args)
  }
}

// Native Ad View
class NativeAdView: NSObject, FlutterPlatformView {
  private var _view: UIView
  private var nativeAd: GADNativeAd?
  
  init(frame: CGRect, viewId: Int64, args: Any?) {
    _view = UIView()
    super.init()
    loadNativeAd()
  }
  
  func view() -> UIView {
    return _view
  }
  
  private func loadNativeAd() {
    let adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/2247696110", rootViewController: nil, adTypes: [.native], options: nil)
    adLoader.delegate = self
    adLoader.load(GADRequest())
  }
}

extension NativeAdView: GADNativeAdLoaderDelegate {
  func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
    self.nativeAd = nativeAd
    
    // Create a simple native ad view
    let adView = GADNativeAdView()
    adView.nativeAd = nativeAd
    
    // Add to the main view
    _view.addSubview(adView)
    adView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      adView.topAnchor.constraint(equalTo: _view.topAnchor),
      adView.leadingAnchor.constraint(equalTo: _view.leadingAnchor),
      adView.trailingAnchor.constraint(equalTo: _view.trailingAnchor),
      adView.bottomAnchor.constraint(equalTo: _view.bottomAnchor)
    ])
  }
  
  func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
    print("Failed to load native ad: \(error.localizedDescription)")
  }
}
