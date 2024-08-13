import 'package:flutter/material.dart';
import 'package:flutter_native_ad/flutter_native_ad.dart';

class NativeVideoAdScreen extends StatefulWidget {
  const NativeVideoAdScreen({Key? key}) : super(key: key);

  @override
  State<NativeVideoAdScreen> createState() => _NativeVideoAdScreenState();
}

class _NativeVideoAdScreenState extends State<NativeVideoAdScreen> {
  final _ad = FlutterNativeAd();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("VideoNativeAd")),
      body: Center(
        child: Column(
          children: [
            Container(height: 255, child: _ad.addVideoNativeAD(context))
          ],
        ),
      ),
    );
  }
}
