package com.example.flutter_native_ad;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class NativeVideoViewFactory extends PlatformViewFactory {

    String videoid;
    NativeVideoViewFactory(String nativeId) {
        super(StandardMessageCodec.INSTANCE);
        videoid = nativeId;
    }

    @NonNull
    @Override
    public PlatformView create(@NonNull Context context, int id, @Nullable Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;

        return new NativeVideoView(context, id, creationParams,videoid);
    }
}
