import 'package:flutter/material.dart';
import 'package:flutter_native_ad/flutter_native_ad.dart';

class NativeBannerAdScreen extends StatefulWidget {
  const NativeBannerAdScreen({super.key});

  @override
  State<NativeBannerAdScreen> createState() => _NativeBannerAdScreenState();
}

class _NativeBannerAdScreenState extends State<NativeBannerAdScreen> {
  bool isNativeAdReady = false;
  final _ad = FlutterNativeAd();
  @override
  void initState() {
    super.initState();
    FlutterNativeAdLogger.screen('initState called');
    loadAd();
  }

  Future<void> loadAd() async {
    FlutterNativeAdLogger.screen('Attempting to load native banner ad...');
    _ad.loadNativeBannerAd(
      // adUnitId: "Your Native Banner Ad ID", // Optional: override with custom ID
      onAdLoaded: (ad) {
        isNativeAdReady = true;
        setState(() {});
        FlutterNativeAdLogger.success('Native banner ad loaded successfully and UI updated');
      },
      onAdFailedToLoad: (ad, error) {
        isNativeAdReady = false;
        ad.dispose();
        FlutterNativeAdLogger.error('Ad load failed (code=${error.code} message=${error.message})');
        FlutterNativeAdLogger.debug('Error domain: ${error.domain}');
        // The throttling system will handle retries automatically
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NativeBannerAd")),
      body: Center(
        child: Column(
          children: [
            SizedBox(
                height: 102,
                child: isNativeAdReady
                    ? _ad.getnativeBannerAD()
                    : SizedBox.shrink())
          ],
        ),
      ),
    );
  }
}
