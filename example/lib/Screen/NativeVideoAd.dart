
import 'package:flutter/material.dart';
import 'package:flutter_native_ad/flutter_native_ad.dart';

class NativeVideoAdPage extends StatefulWidget {
  const NativeVideoAdPage({Key? key}) : super(key: key);

  @override
  State<NativeVideoAdPage> createState() => _NativeVideoAdPageState();
}

class _NativeVideoAdPageState extends State<NativeVideoAdPage> {
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
            Container(height: 255,child:  _ad.addVideoNativeAD(context))
          ],
        ),
      ),
    );
  }
}



