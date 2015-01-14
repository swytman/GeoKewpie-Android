package com.geokewpie.services.updateLocation;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class UpdateLocationAlarmReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        System.out.println("UpdateLocationAlarmReceiver executed");
        Intent i = new Intent(context, UpdateLocationService.class);
        context.startService(i);
    }
}
