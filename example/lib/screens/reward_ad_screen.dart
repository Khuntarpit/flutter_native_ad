
import 'package:flutter/material.dart';
import 'package:flutter_native_ad/flutter_rewarded_ad.dart';

class RewardedAdScreen extends StatefulWidget {
  const RewardedAdScreen({Key? key}) : super(key: key);

  @override
  State<RewardedAdScreen> createState() => _RewardedAdScreenState();
}

class _RewardedAdScreenState extends State<RewardedAdScreen> {

  final _rewardedAd = FlutterRewardedAd();
  bool isRewardedAdReady = false;
  @override
  void initState() {
    super.initState();
    loadAds();
  }

  loadAds() async{
    await _rewardedAd.loadRewardedAd(
      onAdLoaded: ( ad) {
        _rewardedAd.rewardedAd = ad;
        isRewardedAdReady = true;
      },
      onAdFailedToLoad: (error) {
        print('Failed to load a rewarded ad: ${error.message}');
        isRewardedAdReady = false;
        loadAds();
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("RewardedAd")),
      body: Center(
        child: ElevatedButton(onPressed: () async{
          isRewardedAdReady
              ? await _rewardedAd.rewardedAd.show(onUserEarnedReward: (ad, reward) {
            loadAds();
              }) : null;

          _rewardedAd.rewardedCallback(onAdDismissedFullScreenContent: (ad) {
            print('$ad onAdDismissedFullScreenContent.');
            ad.dispose();
            loadAds();
          },onAdFailedToShowFullScreenContent: (ad,error) {
            print('$ad onAdFailedToShowFullScreenContent: $error');
            ad.dispose();
            loadAds();
          });
        },
            child: const Text("RewardedAd")),
      ),
    );
  }
}
