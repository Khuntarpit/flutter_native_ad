import 'package:flutter/material.dart';
import 'package:flutter_native_ad/flutter_native_ad.dart';

class NativeBannerAdScreen extends StatefulWidget {
  const NativeBannerAdScreen({Key? key}) : super(key: key);

  @override
  State<NativeBannerAdScreen> createState() => _NativeBannerAdScreenState();
}

class _NativeBannerAdScreenState extends State<NativeBannerAdScreen> {
  bool isNativeAdReady = false;
  final _ad = FlutterNativeAd();
  @override
  void initState() {
    super.initState();
    loadAd();
  }


  loadAd() async{
    await _ad.loadNativeBannerAd(
      adUnitId: "Your Native Banner Ad ID",
      onAdLoaded: (ad) {
        isNativeAdReady = true;
        setState(()=>"");
      },
      onAdFailedToLoad:(ad, error) {
        _ad.loadNativeBannerAd();
        isNativeAdReady = false;
        ad.dispose();
        print('Ad load failed (code=${error.code} message=${error.message})');
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

            Container(height: 102,child: isNativeAdReady?_ad.getnativeBannerAD() :SizedBox.shrink())
          ],
        ),
      ),
    );
  }
}
