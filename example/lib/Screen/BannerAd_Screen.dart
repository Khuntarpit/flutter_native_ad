import 'package:flutter/material.dart';
import 'package:flutter_native_ad/flutter_native_ad.dart';

class BannerAdPage extends StatefulWidget {
  const BannerAdPage({Key? key}) : super(key: key);

  @override
  State<BannerAdPage> createState() => _BannerAdPageState();
}

class _BannerAdPageState extends State<BannerAdPage> {

  final _adBanner = FlutterBannerAd();
  var isBannerAdReady = false;
  @override
  void initState() {
    super.initState();
    loadAd();
  }

  loadAd() async{
   await _adBanner.loadBannerAd(onAdLoaded: (_) {
      isBannerAdReady = true;
      setState(()=>"");
    },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          isBannerAdReady = false;
          ad.dispose();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BannerAd")),
      body: Center(
        child: Column(
          children: [
            Container(height: 50,child: isBannerAdReady ?_adBanner.getBannerAd() : SizedBox.shrink())
          ],
        ),
      ),
    );
  }
}
