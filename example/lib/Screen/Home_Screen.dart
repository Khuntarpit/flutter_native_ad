import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_ad_example/Screen/AdOpenAd_Screen.dart';
import 'package:flutter_native_ad_example/Screen/BannerAd_Screen.dart';
import 'package:flutter_native_ad_example/Screen/InterstitialAd_Screen.dart';
import 'package:flutter_native_ad_example/Screen/NativeBannerAd.dart';
import 'package:flutter_native_ad_example/Screen/NativeMediumAd.dart';
import 'package:flutter_native_ad_example/Screen/NativeVideoAd.dart';
import 'package:flutter_native_ad_example/Screen/RewardAd_Screen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("mediumNativeAd")),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [

                const SizedBox(height: 20),
                ElevatedButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => NativeBannerAdPage(),));

                }, child: const Text("NativeBannerAd")),


                const SizedBox(height: 20),
                ElevatedButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => NativeMediumAd(),));

                }, child: const Text("NativeMediumAd")),


                const SizedBox(height: 20),
                ElevatedButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => NativeVideoAdPage(),));

                }, child: const Text("VideoNativeAd")),


                const SizedBox(height: 20),
                ElevatedButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => BannerAdPage()));

                }, child: const Text("BannerAd")),


                const SizedBox(height: 20),
                ElevatedButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => InterstitialAdPage()));

                }, child: const Text("InterstitialAD")),


                 const SizedBox(height: 20),
                ElevatedButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RewardedAdPage()));

                }, child: const Text("RewardedAd")),


                const SizedBox(height: 20),
                ElevatedButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdOpenAdPage()));

                }, child: const Text("AdOpenAd")),

                
              ],
            ),
          ),
        ));
  }
}
