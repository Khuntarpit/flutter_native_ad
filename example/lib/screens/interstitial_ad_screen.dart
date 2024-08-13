import 'package:flutter/material.dart';
import 'package:flutter_native_ad/flutter_interstitial_ad.dart';

class InterstitialAdScreen extends StatefulWidget {
  const InterstitialAdScreen({Key? key}) : super(key: key);

  @override
  State<InterstitialAdScreen> createState() => _InterstitialAdScreenState();
}

class _InterstitialAdScreenState extends State<InterstitialAdScreen> {

  bool isInterstitialAdReady = false;
  bool isRewardedInterstitialAdReady = false;
  final _interstitialAd = FlutterInterstitialAd();
  @override
  void initState() {
    super.initState();
    loadAds();
  }

  loadAds() async{
    await _loadInterstitialAd();
    await _loadRewardedInterstitialAd();

  }

  _loadInterstitialAd() async{
    await _interstitialAd.loadInterstitialAd(
      onAdLoaded: (ad) {
        _interstitialAd.interstitialAd = ad;
        isInterstitialAdReady = true;
      },
      onAdFailedToLoad: (err) {
        print('Failed to load an interstitial ad: ${err.message}');
        isInterstitialAdReady = false;
        _loadInterstitialAd();
      },
    );
  }

  _loadRewardedInterstitialAd() async{
    await _interstitialAd.loadRewardedInterstitialAd(
      onAdLoaded: (ad) {
        _interstitialAd.rewardedInterstitial = ad;
        isRewardedInterstitialAdReady = true;
      },
      onAdFailedToLoad: (error) {
        isRewardedInterstitialAdReady = false;
        print('RewardedInterstitialAd failed to load: $error');
        _loadRewardedInterstitialAd();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("InterstitialAD")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async{
                  isInterstitialAdReady ? await _interstitialAd.interstitialAd?.show() : null;
                  _loadInterstitialAd();
                },
                child: const Text("InterstitialAd")),


            SizedBox(height: 10),
            ElevatedButton(onPressed: () async{
              isRewardedInterstitialAdReady
                  ? await _interstitialAd.rewardedInterstitial?.show(
                  onUserEarnedReward: (ad,reward) {
                    _loadRewardedInterstitialAd();

                  })
                  : null;

              _interstitialAd.rewardedInterstitialCallback(onAdDismissedFullScreenContent: (ad) {
                print('$ad onAdDismissedFullScreenContent.');
                ad.dispose();
                _loadRewardedInterstitialAd();
              },onAdFailedToShowFullScreenContent: (ad,error) {
                print('$ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();
                _loadRewardedInterstitialAd();
              });
            },
                child: const Text("RewardedInterstitialAd")),
          ],
        ),
      ),
    );

  }
}
