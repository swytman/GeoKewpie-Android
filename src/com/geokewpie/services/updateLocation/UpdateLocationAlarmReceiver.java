package com.geokewpie.services.updateLocation;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class UpdateLocationAlarmReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        Intent myService = new Intent(context, UpdateLocationService.class);
        context.startService(myService);
    }
}
