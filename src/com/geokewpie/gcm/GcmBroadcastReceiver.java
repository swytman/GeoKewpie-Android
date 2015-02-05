package com.geokewpie.gcm;

import android.app.Activity;
import android.content.*;
import android.support.v4.content.WakefulBroadcastReceiver;
import com.geokewpie.services.updateLocation.UpdateLocationService;

public class GcmBroadcastReceiver extends WakefulBroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        ComponentName comp = new ComponentName(context.getPackageName(), UpdateLocationService.class.getName());
        // Start the service, keeping the device awake while it is launching.
        startWakefulService(context, (intent.setComponent(comp)));
        setResultCode(Activity.RESULT_OK);
    }
}
