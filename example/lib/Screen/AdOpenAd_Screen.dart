import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_native_ad/flutter_native_ad.dart';

class AdOpenAdPage extends StatefulWidget {
  const AdOpenAdPage({Key? key}) : super(key: key);

  @override
  State<AdOpenAdPage> createState() => _AdOpenAdPageState();
}

class _AdOpenAdPageState extends State<AdOpenAdPage> {
  bool isAppOpenAdAdReady = false;

  final _adOpenAd = FlutterAdOpenAd();

  @override
  void initState(){
    super.initState();
    loadAd();

  }
  loadAd() async{

    await _adOpenAd.loadAppOpenAd(onAdLoaded:(ad) {
      print('$ad loaded');
      _adOpenAd.appOpenAd = ad;
      isAppOpenAdAdReady = true;
    }, onAdFailedToLoad:   (error) {
      isAppOpenAdAdReady = false;
      print('AppOpenAd failed to load: $error');
      loadAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AdOpenAd")),
      body: Center(
        child: ElevatedButton(onPressed: () async{
          isAppOpenAdAdReady ? await _adOpenAd.appOpenAd?.show() : null;
          loadAd();
          _adOpenAd.appOpenAdCallback(onAdFailedToShowFullScreenContent: (ad, error) {
            print('$ad onAdFailedToShowFullScreenContent: $error');
            ad.dispose();
            loadAd();
          },onAdDismissedFullScreenContent: (ad) {
              print('$ad onAdDismissedFullScreenContent');
              ad.dispose();
              loadAd();
            },
          );
        },
            child: const Text("AdOpenAd")),
      ),
    );
  }
}
