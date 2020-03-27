package it.rignanese.leo.gallerytrigger;

import androidx.annotation.NonNull;

import android.content.Intent;
import android.net.Uri;
import android.content.Context;
import java.io.File;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * GallerytriggerPlugin
 */
public class GallerytriggerPlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;
    private Context applicationContext;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "gallerytrigger");
        channel.setMethodCallHandler(this);
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "gallerytrigger");
        channel.setMethodCallHandler(new GallerytriggerPlugin());

        final GallerytriggerPlugin instance = new GallerytriggerPlugin();
        instance.onAttachedToEngine(registrar.context());
    }

    private void onAttachedToEngine(Context applicationContext) {
        this.applicationContext = applicationContext;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("refreshMediaStore")) {
            String path = call.argument("path");
            refreshMediaStore(path);
            result.success(true);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private void refreshMediaStore(@NonNull String filePath) {
        Intent intent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
        intent.setData(Uri.fromFile(new File(filePath)));
        applicationContext.sendBroadcast(intent);
    }
}
