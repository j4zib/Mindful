/*
 *
 *  *
 *  *  * Copyright (c) 2024 Mindful (https://github.com/akaMrNagar/Mindful)
 *  *  * Author : Pawan Nagar (https://github.com/akaMrNagar)
 *  *  *
 *  *  * This source code is licensed under the GPL-2.0 license license found in the
 *  *  * LICENSE file in the root directory of this source tree.
 *  *
 *
 */

package com.mindful.android.receivers;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.mindful.android.generics.SafeServiceConnection;
import com.mindful.android.helpers.AlarmTasksSchedulingHelper;
import com.mindful.android.helpers.SharedPrefsHelper;
import com.mindful.android.services.MindfulTrackerService;
import com.mindful.android.services.MindfulVpnService;
import com.mindful.android.utils.Utils;

/**
 * BroadcastReceiver that handles actions after the device boots up.
 */
public class DeviceBootReceiver extends BroadcastReceiver {
    private static final String TAG = "Mindful.DeviceBootReceiver";

    @SuppressLint("UnsafeProtectedBroadcastReceiver")
    @Override
    public void onReceive(Context context, Intent intent) {
        /// The null safe method gets the action from the intent so we can suppress the warning
        // for 'UnsafeProtectedBroadcastReceiver' but the receiver is safe, just moved the logic to a util method
        String action = Utils.getActionFromIntent(intent);

        if (Intent.ACTION_BOOT_COMPLETED.equals(action) || Intent.ACTION_MY_PACKAGE_REPLACED.equals(action)) {
            Log.d(TAG, "onReceive: Device reboot broadcast received. Now doing the needful");

            // Fetch bedtime settings to check if the bedtime schedule is on
            boolean isBedtimeScheduleOn = SharedPrefsHelper.fetchBedtimeSettings(context).isScheduleOn;

            // Start the MindfulTrackerService if needed
            if (!SharedPrefsHelper.fetchAppTimers(context).isEmpty()) {
                SafeServiceConnection<MindfulTrackerService> mTrackerServiceConn = new SafeServiceConnection<>(MindfulTrackerService.class, context);
                mTrackerServiceConn.startOnly(MindfulTrackerService.ACTION_START_SERVICE_TIMER_MODE);
            }

            // Start the MindfulVpnService if needed
            if (!SharedPrefsHelper.fetchBlockedApps(context).isEmpty() && MindfulVpnService.prepare(context) == null) {
                SafeServiceConnection<MindfulVpnService> mVpnServiceConn = new SafeServiceConnection<>(MindfulVpnService.class, context);
                mVpnServiceConn.startOnly(MindfulVpnService.ACTION_START_SERVICE_VPN);
            }

            // Reschedule bedtime workers if the bedtime schedule is on
            if (isBedtimeScheduleOn) AlarmTasksSchedulingHelper.scheduleBedtimeStartTask(context);

            // Reschedule midnight reset worker
            AlarmTasksSchedulingHelper.scheduleMidnightResetTask(context, false);
        }
    }
}
