import 'package:flutter/material.dart';
import 'package:flutter_native_ad/flutter_native_ad.dart';

class BannerAdScreen extends StatefulWidget {
  const BannerAdScreen({Key? key}) : super(key: key);

  @override
  State<BannerAdScreen> createState() => _BannerAdScreenState();
}

class _BannerAdScreenState extends State<BannerAdScreen> {
  final _adBanner = FlutterBannerAd();
  var isBannerAdReady = false;
  @override
  void initState() {
    super.initState();
    loadAd();
  }

  loadAd() async {
    print('🎯 [BANNER SCREEN] Attempting to load banner ad...');
    await _adBanner.loadBannerAd(
      // adUnitId: "Your Banner Ad ID", // Optional: override with custom ID
      onAdLoaded: (_) {
        isBannerAdReady = true;
        setState(() {});
        print('🎉 [BANNER SCREEN] Banner ad loaded successfully and UI updated');
      },
      onAdFailedToLoad: (ad, err) {
        print('💥 [BANNER SCREEN] Failed to load banner ad: ${err.message}');
        print('🔍 [BANNER SCREEN] Error code: ${err.code}, domain: ${err.domain}');
        isBannerAdReady = false;
        ad.dispose();
        // The throttling system will handle retries automatically
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BannerAd")),
      body: Center(
        child: Column(
          children: [
            Container(
                height: 50,
                child: isBannerAdReady
                    ? _adBanner.getBannerAd()
                    : SizedBox.shrink())
          ],
        ),
      ),
    );
  }
}
