import 'package:flutter/material.dart';
import 'package:flutter_native_ad/flutter_native_ad.dart';

class NativeMediumAdScreen extends StatefulWidget {
  const NativeMediumAdScreen({Key? key}) : super(key: key);

  @override
  State<NativeMediumAdScreen> createState() => _NativeMediumAdScreenState();
}

class _NativeMediumAdScreenState extends State<NativeMediumAdScreen> {
  bool isMediumNativeAdReady = false;
  final _ad = FlutterNativeAd();
  @override
  void initState() {
    super.initState();
    loadAd();
  }


  loadAd() async{
    await _ad.loadmediumNativeAd(
      onAdLoaded: (ad) {
        isMediumNativeAdReady = true;
        setState(()=>"");
      },
      onAdFailedToLoad:(ad, error) {
        _ad.loadmediumNativeAd();
        isMediumNativeAdReady = false;
        ad.dispose();
        print('Ad load failed (code=${error.code} message=${error.message})');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NativeMediumAdScreen")),
      body: Center(
        child: Column(
          children: [
            Container(height: 255,child: isMediumNativeAdReady ?_ad.getMediumNativeAD() : SizedBox.shrink())
          ],
        ),
      ),
    );
  }
}

