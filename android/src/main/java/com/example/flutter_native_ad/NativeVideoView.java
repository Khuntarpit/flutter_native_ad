package com.example.flutter_native_ad;

import android.content.Context;
import android.os.CountDownTimer;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdLoader;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.VideoController;
import com.google.android.gms.ads.VideoOptions;
import com.google.android.gms.ads.initialization.InitializationStatus;
import com.google.android.gms.ads.initialization.OnInitializationCompleteListener;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdOptions;

import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

public class NativeVideoView implements PlatformView {

    @NonNull private View templateView;
    private static final String TAG = "-->Native";
    private TemplateView template;


    NativeVideoView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams, String videoid) {
//        template = new TemplateView(context);
//        templateView
//        textView = new TextView(context);
//        textView.setTextSize(72);
//        textView.setBackgroundColor(Color.rgb(255, 255, 255));
//        textView.setText("Rendered on a native Android view (id: " + id + ")");

        templateView = LayoutInflater.from(context).inflate(R.layout.activity_main, null);
        template = templateView.findViewById(R.id.my_template);

        //---> initializing Google Ad SDK
        MobileAds.initialize(context, new OnInitializationCompleteListener() {
            @Override
            public void onInitializationComplete(InitializationStatus initializationStatus) {

                loadAd(context,videoid);
            }
        });


    }


    private void loadAd(Context context, String videoid) {

        Log.d(TAG, "Google SDK Initialized");

        VideoOptions videoOptions = new VideoOptions.Builder()
                .setStartMuted(false)
                .build();

        NativeAdOptions adOptions = new NativeAdOptions.Builder()
                .setVideoOptions(videoOptions)
                .build();


        AdLoader adLoader = new AdLoader.Builder(context, videoid)
                .forNativeAd(new NativeAd.OnNativeAdLoadedListener() {
                    @Override
                    public void onNativeAdLoaded(NativeAd nativeAd) {
                        Log.d(TAG, "Native Ad Loaded");

//                        if (isDestroyed()) {
//                            nativeAd.destroy();
//                            Log.d(TAG, "Native Ad Destroyed");
//                            return;
//                        }
//                        if (isDestroyed()) {
//                            nativeAd.destroy();
//                            Log.d(TAG, "Native Ad Destroyed");
//                            return;
//                        }


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
                                loadAd(context, videoid);
                            }
                        };

                    }
                })
//                        .withNativeAdOptions(new NativeAdOptions.Builder().build())
                .withNativeAdOptions(adOptions)
                .build();

        adLoader.loadAd(new AdRequest.Builder().build());
    }


    @Nullable
    @Override
    public View getView() {
        return templateView;
    }

    @Override
    public void dispose() {

    }

}