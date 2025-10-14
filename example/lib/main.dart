import 'package:flutter/material.dart';
import 'package:flutter_native_ad/flutter_native_ad.dart';
import 'screens/home_screen.dart';
import 'production_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterNativeAdLogger.screen('initState called, starting ad initialization...');
    _initializeAds();
  }

  void _initializeAds() async {
    // Configure logging based on build type
    // For production builds, use: ProductionConfig.configureForProduction();
    // For debug builds, use: ProductionConfig.configureForDebug();
    ProductionConfig.configureForDebug(); // Currently using debug mode
    
    FlutterNativeAdLogger.init('Starting ad initialization...');
    
    // Reset throttling to start fresh
    AdRequestThrottler.resetAll();
    FlutterNativeAdLogger.throttling('Reset completed');
    
    // Initialize with test mode and test device IDs
    FlutterNativeAdConfig.initialize(
      isTestMode: true, // Set to false for production
      testDeviceIds: [
        "BC754A812958EE7FF20599662417762B", // Default test device ID
        "DCC32562C291DD0DA9E7ECD226EB1029", // Your device ID from logs
        // Add more test device IDs as needed
      ],
      // Production ad unit IDs (uncomment and set when ready for production)
      // bannerAdUnitId: "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX",
      // interstitialAdUnitId: "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX",
      // rewardedAdUnitId: "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX",
      // rewardedInterstitialAdUnitId: "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX",
      // appOpenAdUnitId: "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX",
      // nativeAdUnitId: "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX",
      // nativeVideoAdUnitId: "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX",
    );
    FlutterNativeAdLogger.config('FlutterNativeAdConfig initialized in TEST mode');
    
    await FlutterNativeAd.init();
    FlutterNativeAdLogger.success('FlutterNativeAd initialization completed');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Native Ad Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
