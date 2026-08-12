import Flutter
import UIKit
import GoogleMobileAds
import google_mobile_ads

public class SwiftFlutterNativeAdPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "flutter_native_ad",
      binaryMessenger: registrar.messenger()
    )
    let instance = SwiftFlutterNativeAdPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    registerFactoriesIfPossible()
  }

  private static func registerFactoriesIfPossible() {
    guard let registry = UIApplication.shared.delegate as? FlutterPluginRegistry else {
      return
    }
    FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
      registry,
      factoryId: "listTile",
      nativeAdFactory: ListTileNativeAdFactory()
    )
    FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
      registry,
      factoryId: "listTileMedium",
      nativeAdFactory: MediumNativeAdFactory()
    )
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getNativeAds":
      if let args = call.arguments as? [String: Any],
         args["nativeVideoID"] is String {
        SwiftFlutterNativeAdPlugin.registerFactoriesIfPossible()
        result(["status": "success", "message": "Native ads registered for iOS"])
      } else {
        result(
          FlutterError(
            code: "INVALID_ARGUMENTS",
            message: "Invalid arguments",
            details: nil
          )
        )
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

/// Small native ad layout — factoryId: "listTile"
public class ListTileNativeAdFactory: NSObject, FLTNativeAdFactory {
  public func createNativeAd(
    _ nativeAd: NativeAd,
    customOptions: [AnyHashable: Any]?
  ) -> NativeAdView? {
    let adView = NativeAdView(frame: .zero)
    adView.backgroundColor = UIColor.secondarySystemBackground

    let iconView = UIImageView()
    iconView.contentMode = .scaleAspectFit
    iconView.translatesAutoresizingMaskIntoConstraints = false

    let headlineLabel = UILabel()
    headlineLabel.font = .boldSystemFont(ofSize: 14)
    headlineLabel.numberOfLines = 1
    headlineLabel.translatesAutoresizingMaskIntoConstraints = false

    let bodyLabel = UILabel()
    bodyLabel.font = .systemFont(ofSize: 12)
    bodyLabel.numberOfLines = 2
    bodyLabel.textColor = .secondaryLabel
    bodyLabel.translatesAutoresizingMaskIntoConstraints = false

    let advertiserLabel = UILabel()
    advertiserLabel.font = .systemFont(ofSize: 11)
    advertiserLabel.textColor = .tertiaryLabel
    advertiserLabel.translatesAutoresizingMaskIntoConstraints = false

    let callToActionButton = UIButton(type: .system)
    callToActionButton.titleLabel?.font = .boldSystemFont(ofSize: 13)
    callToActionButton.translatesAutoresizingMaskIntoConstraints = false
    callToActionButton.isUserInteractionEnabled = false

    let attributionLabel = UILabel()
    attributionLabel.text = "Ad"
    attributionLabel.font = .systemFont(ofSize: 10, weight: .semibold)
    attributionLabel.textColor = .white
    attributionLabel.backgroundColor = .systemYellow
    attributionLabel.textAlignment = .center
    attributionLabel.translatesAutoresizingMaskIntoConstraints = false

    adView.addSubview(attributionLabel)
    adView.addSubview(iconView)
    adView.addSubview(headlineLabel)
    adView.addSubview(bodyLabel)
    adView.addSubview(advertiserLabel)
    adView.addSubview(callToActionButton)

    NSLayoutConstraint.activate([
      attributionLabel.topAnchor.constraint(equalTo: adView.topAnchor, constant: 4),
      attributionLabel.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 8),
      attributionLabel.widthAnchor.constraint(equalToConstant: 24),
      attributionLabel.heightAnchor.constraint(equalToConstant: 14),

      iconView.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 8),
      iconView.centerYAnchor.constraint(equalTo: adView.centerYAnchor),
      iconView.widthAnchor.constraint(equalToConstant: 40),
      iconView.heightAnchor.constraint(equalToConstant: 40),

      headlineLabel.topAnchor.constraint(equalTo: adView.topAnchor, constant: 8),
      headlineLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
      headlineLabel.trailingAnchor.constraint(equalTo: callToActionButton.leadingAnchor, constant: -8),

      bodyLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 2),
      bodyLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
      bodyLabel.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor),

      advertiserLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 2),
      advertiserLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
      advertiserLabel.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor),
      advertiserLabel.bottomAnchor.constraint(lessThanOrEqualTo: adView.bottomAnchor, constant: -8),

      callToActionButton.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -8),
      callToActionButton.centerYAnchor.constraint(equalTo: adView.centerYAnchor),
      callToActionButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 72),
      callToActionButton.heightAnchor.constraint(equalToConstant: 32),
    ])

    adView.iconView = iconView
    adView.headlineView = headlineLabel
    adView.bodyView = bodyLabel
    adView.advertiserView = advertiserLabel
    adView.callToActionView = callToActionButton

    headlineLabel.text = nativeAd.headline

    bodyLabel.text = nativeAd.body
    bodyLabel.isHidden = nativeAd.body == nil

    advertiserLabel.text = nativeAd.advertiser
    advertiserLabel.isHidden = nativeAd.advertiser == nil

    iconView.image = nativeAd.icon?.image
    iconView.isHidden = nativeAd.icon == nil

    callToActionButton.setTitle(nativeAd.callToAction, for: .normal)
    callToActionButton.isHidden = nativeAd.callToAction == nil

    adView.nativeAd = nativeAd
    return adView
  }
}

/// Medium native ad layout — factoryId: "listTileMedium"
public class MediumNativeAdFactory: NSObject, FLTNativeAdFactory {
  public func createNativeAd(
    _ nativeAd: NativeAd,
    customOptions: [AnyHashable: Any]?
  ) -> NativeAdView? {
    let adView = NativeAdView(frame: .zero)
    adView.backgroundColor = UIColor.secondarySystemBackground

    let iconView = UIImageView()
    iconView.contentMode = .scaleAspectFit
    iconView.translatesAutoresizingMaskIntoConstraints = false

    let headlineLabel = UILabel()
    headlineLabel.font = .boldSystemFont(ofSize: 16)
    headlineLabel.numberOfLines = 2
    headlineLabel.translatesAutoresizingMaskIntoConstraints = false

    let bodyLabel = UILabel()
    bodyLabel.font = .systemFont(ofSize: 13)
    bodyLabel.numberOfLines = 3
    bodyLabel.textColor = .secondaryLabel
    bodyLabel.translatesAutoresizingMaskIntoConstraints = false

    let advertiserLabel = UILabel()
    advertiserLabel.font = .systemFont(ofSize: 12)
    advertiserLabel.textColor = .tertiaryLabel
    advertiserLabel.translatesAutoresizingMaskIntoConstraints = false

    let mediaView = MediaView()
    mediaView.translatesAutoresizingMaskIntoConstraints = false

    let callToActionButton = UIButton(type: .system)
    callToActionButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
    callToActionButton.translatesAutoresizingMaskIntoConstraints = false
    callToActionButton.isUserInteractionEnabled = false

    let attributionLabel = UILabel()
    attributionLabel.text = "Ad"
    attributionLabel.font = .systemFont(ofSize: 10, weight: .semibold)
    attributionLabel.textColor = .white
    attributionLabel.backgroundColor = .systemYellow
    attributionLabel.textAlignment = .center
    attributionLabel.translatesAutoresizingMaskIntoConstraints = false

    adView.addSubview(attributionLabel)
    adView.addSubview(iconView)
    adView.addSubview(headlineLabel)
    adView.addSubview(advertiserLabel)
    adView.addSubview(mediaView)
    adView.addSubview(bodyLabel)
    adView.addSubview(callToActionButton)

    NSLayoutConstraint.activate([
      attributionLabel.topAnchor.constraint(equalTo: adView.topAnchor, constant: 8),
      attributionLabel.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 8),
      attributionLabel.widthAnchor.constraint(equalToConstant: 24),
      attributionLabel.heightAnchor.constraint(equalToConstant: 14),

      iconView.topAnchor.constraint(equalTo: attributionLabel.bottomAnchor, constant: 8),
      iconView.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 8),
      iconView.widthAnchor.constraint(equalToConstant: 48),
      iconView.heightAnchor.constraint(equalToConstant: 48),

      headlineLabel.topAnchor.constraint(equalTo: iconView.topAnchor),
      headlineLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
      headlineLabel.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -8),

      advertiserLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 2),
      advertiserLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
      advertiserLabel.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor),

      mediaView.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),
      mediaView.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 8),
      mediaView.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -8),
      mediaView.heightAnchor.constraint(equalToConstant: 120),

      bodyLabel.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: 8),
      bodyLabel.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 8),
      bodyLabel.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -8),

      callToActionButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 8),
      callToActionButton.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 8),
      callToActionButton.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -8),
      callToActionButton.heightAnchor.constraint(equalToConstant: 36),
      callToActionButton.bottomAnchor.constraint(equalTo: adView.bottomAnchor, constant: -8),
    ])

    adView.iconView = iconView
    adView.headlineView = headlineLabel
    adView.bodyView = bodyLabel
    adView.advertiserView = advertiserLabel
    adView.mediaView = mediaView
    adView.callToActionView = callToActionButton

    headlineLabel.text = nativeAd.headline
    mediaView.mediaContent = nativeAd.mediaContent

    bodyLabel.text = nativeAd.body
    bodyLabel.isHidden = nativeAd.body == nil

    advertiserLabel.text = nativeAd.advertiser
    advertiserLabel.isHidden = nativeAd.advertiser == nil

    iconView.image = nativeAd.icon?.image
    iconView.isHidden = nativeAd.icon == nil

    callToActionButton.setTitle(nativeAd.callToAction, for: .normal)
    callToActionButton.isHidden = nativeAd.callToAction == nil

    adView.nativeAd = nativeAd
    return adView
  }
}
