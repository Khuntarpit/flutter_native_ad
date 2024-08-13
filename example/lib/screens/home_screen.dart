import 'package:flutter/material.dart';
import 'interstitial_ad_screen.dart';
import 'native_banner_ad_screen.dart';
import 'native_medium_ad_screen.dart';
import 'native_video_ad_screen.dart';
import 'open_ad_screen.dart';
import 'reward_ad_screen.dart';
import 'banner_ad_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Home")),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NativeBannerAdScreen(),
                      ));
                    },
                    child: const Text("NativeBannerAd")),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NativeMediumAdScreen(),
                      ));
                    },
                    child: const Text("NativeMediumAd")),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NativeVideoAdScreen(),
                      ));
                    },
                    child: const Text("VideoNativeAd")),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BannerAdScreen()));
                    },
                    child: const Text("BannerAd")),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InterstitialAdScreen()));
                    },
                    child: const Text("InterstitialAD")),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RewardedAdScreen()));
                    },
                    child: const Text("RewardedAd")),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AdOpenAdScreen()));
                    },
                    child: const Text("AdOpenAd")),
              ],
            ),
          ),
        ));
  }
}
