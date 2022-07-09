import 'package:flutter/material.dart';
import 'package:flutter_native_ad/flutter_native_ad.dart';

class NativeMediumAd extends StatefulWidget {
  const NativeMediumAd({Key? key}) : super(key: key);

  @override
  State<NativeMediumAd> createState() => _NativeMediumAdState();
}

class _NativeMediumAdState extends State<NativeMediumAd> {
  bool ismediumNativeAdReady = false;
  final _ad = FlutterNativeAd();
  @override
  void initState() {
    super.initState();
    loadAd();
  }


  loadAd() async{
    await _ad.loadmediumNativeAd(onAdLoaded: (ad) {
      ismediumNativeAdReady = true;
      setState(()=>"");
    },onAdFailedToLoad:(ad, error) {
      _ad.loadmediumNativeAd();
      ismediumNativeAdReady = false;
      ad.dispose();
      print('Ad load failed (code=${error.code} message=${error.message})');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NativeMediumAd")),
      body: Center(
        child: Column(
          children: [
            Container(height: 255,child: ismediumNativeAdReady ?_ad.getMediumNativeAD() : SizedBox.shrink())
          ],
        ),
      ),
    );
  }
}

