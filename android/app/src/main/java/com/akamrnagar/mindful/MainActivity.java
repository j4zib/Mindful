package com.akamrnagar.mindful;

import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;

import com.akamrnagar.mindful.helpers.DeviceAppsHelper;
import com.akamrnagar.mindful.services.MindfulAppsTrackerService;
import com.akamrnagar.mindful.utils.AppConstants;
import com.akamrnagar.mindful.utils.Utils;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.util.PathUtils;

public class MainActivity extends FlutterActivity implements MethodChannel.MethodCallHandler {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), AppConstants.METHOD_CHANNEL);
        channel.setMethodCallHandler(this);

        String appPackage = getIntent().getStringExtra("appPackage");

        if (appPackage != null && !appPackage.isEmpty()) {
            channel.invokeMethod("openAppDashboard", appPackage);
        }
        // check if [MindfulAppsTrackerService] service is running or not
        // if its not running then start it
//        checkAndStartService();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "getAppDirectoryPath":
                result.success(PathUtils.getDataDirectory(getApplicationContext()));
                break;
            case "getDeviceApps":
                DeviceAppsHelper.getDeviceApps(getApplicationContext(), result);
                break;
            case "checkAndStartService":
                checkAndStartService();
                result.success(true);
                break;
            case "restartService":
                restartService();
                result.success(true);
                break;
            default:
                result.notImplemented();
        }

    }

    private void checkAndStartService() {
        if (!Utils.isServiceRunning(getApplicationContext(), MindfulAppsTrackerService.class.getName())) {
            Intent intent = new Intent(getApplicationContext(), MindfulAppsTrackerService.class);
            getApplicationContext().startService(intent);
            Log.d(AppConstants.DEBUG_TAG, "started service : MindfulAppsTrackerService()");
        }
    }

    private void restartService() {
        Intent intent = new Intent(getApplicationContext(), MindfulAppsTrackerService.class);
        if (Utils.isServiceRunning(getApplicationContext(), MindfulAppsTrackerService.class.getName())) {
            getApplicationContext().stopService(intent);
        }

        getApplicationContext().startService(intent);
        Log.d(AppConstants.DEBUG_TAG, "restarted service : MindfulAppsTrackerService()");
    }

}
