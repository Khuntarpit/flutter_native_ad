import 'package:flutter/material.dart';
import 'package:flutter_native_ad/flutter_native_ad.dart';

class NativeBannerAdPage extends StatefulWidget {
  const NativeBannerAdPage({Key? key}) : super(key: key);

  @override
  State<NativeBannerAdPage> createState() => _NativeBannerAdPageState();
}

class _NativeBannerAdPageState extends State<NativeBannerAdPage> {
  bool isNativeAdReady = false;
  final _ad = FlutterNativeAd();
  @override
  void initState() {
    super.initState();
    loadAd();
  }


  loadAd() async{
    await _ad.loadNativeBannerAd(onAdLoaded: (ad) {
      isNativeAdReady = true;
      setState(()=>"");
    },onAdFailedToLoad:(ad, error) {
      _ad.loadNativeBannerAd();
      isNativeAdReady = false;
      ad.dispose();
      print('Ad load failed (code=${error.code} message=${error.message})');
    });
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
