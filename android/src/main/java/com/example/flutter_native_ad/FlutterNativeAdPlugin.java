package com.example.flutter_native_ad;

import android.app.Activity;
import android.content.Context;
import android.os.CountDownTimer;
import android.util.Log;
import android.view.View;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdLoader;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.VideoController;
import com.google.android.gms.ads.VideoOptions;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdOptions;

import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;


/** FlutterNativeAdPlugin */
public class FlutterNativeAdPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private MethodChannel nativeChannel;
  private Context context;
  private Activity activity;
  private FlutterEngine flutterEngine;

  private TemplateView template;
  private static final String TAG = "-->Native";
  FlutterPluginBinding pluginBinding;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_native_ad");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
    flutterEngine = flutterPluginBinding.getFlutterEngine();
    pluginBinding = flutterPluginBinding;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {


    if (call.method.equals("getNativeAds")) {

      GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "listTile", new NativeAdFactorySmall(context));
      GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "listTileMedium", new NativeAdFactoryMedium(context));

        Map<String, String> arguments = call.arguments();
        String nativeId = arguments.get("nativeVideoID");

        pluginBinding.getPlatformViewRegistry().registerViewFactory("<platform-view-type>", new NativeVideoViewFactory(nativeId));
    } else {
      result.notImplemented();
    }
  }


  // Activity Aware
  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTile");
    GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTileMedium");
    channel.setMethodCallHandler(null);
  }


      private void loadAd() {

        Log.d(TAG, "Google SDK Initialized");

        VideoOptions videoOptions = new VideoOptions.Builder()
                .setStartMuted(false)
                .build();

        NativeAdOptions adOptions = new NativeAdOptions.Builder()
                .setVideoOptions(videoOptions)
                .build();


        AdLoader adLoader = new AdLoader.Builder(context, "ca-app-pub-3940256099942544/1044960115")

                .forNativeAd(new NativeAd.OnNativeAdLoadedListener() {
                    @Override
                    public void onNativeAdLoaded(NativeAd nativeAd) {
                        Log.d(TAG, "Native Ad Loaded");


                        if (activity.isDestroyed()) {
                            nativeAd.destroy();
                            Log.d(TAG, "Native Ad Destroyed");
                            return;
                        }

                        if (nativeAd.getMediaContent().hasVideoContent()) {
                            float mediaAspectRatio = nativeAd.getMediaContent().getAspectRatio();
                            float duration = nativeAd.getMediaContent().getDuration();

                            nativeAd.getMediaContent().getVideoController().setVideoLifecycleCallbacks(new VideoController.VideoLifecycleCallbacks() {
                                @Override
                                public void onVideoEnd() {
                                    super.onVideoEnd();
                                    Log.d(TAG,"VideoEnd");
                                }

                                @Override
                                public void onVideoMute(boolean b) {
                                    super.onVideoMute(b);
                                    Log.d(TAG,"VideoMute : "+ b);
                                }

                                @Override
                                public void onVideoPause() {
                                    super.onVideoPause();
                                    Log.d(TAG,"VideoPause");

                                }

                                @Override
                                public void onVideoPlay() {
                                    super.onVideoPlay();

                                    Log.d(TAG,"VideoPlay");

                                }

                                @Override
                                public void onVideoStart() {
                                    super.onVideoStart();
                                    Log.d(TAG,"VideoStart");
                                }
                            });
                        }

                        NativeTemplateStyle styles = new
                                NativeTemplateStyle.Builder().build();


                        template.setStyles(styles);
                        template.setVisibility(View.VISIBLE);
                        template.setNativeAd(nativeAd);

                    }
                })

                .withAdListener(new AdListener() {
                    @Override
                    public void onAdFailedToLoad(LoadAdError adError) {
                        // Handle the failure by logging, altering the UI, and so on.
                        Log.d(TAG, "Native Ad Failed To Load");
                        template.setVisibility(View.GONE);

                        new CountDownTimer(10000,1000){


                            @Override
                            public void onTick(long millisUntilFinished) {
                                Log.d(TAG,"Sec : "+millisUntilFinished/1000);

                            }

                            @Override
                            public void onFinish() {
                                Log.d(TAG,"Reloading Native Ad");
                                loadAd();
                            }
                        };

                    }
                })
//                        .withNativeAdOptions(new NativeAdOptions.Builder().build())
                .withNativeAdOptions(adOptions)
                .build();

        adLoader.loadAd(new AdRequest.Builder().build());
    }

}
