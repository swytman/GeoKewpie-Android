package com.geokewpie.services.updateLocation;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.widget.Toast;
import com.geokewpie.R;
import com.geokewpie.content.Properties;
import com.geokewpie.tasks.UpdateLocationTask;
import com.littlefluffytoys.littlefluffylocationlibrary.LocationInfo;
import com.littlefluffytoys.littlefluffylocationlibrary.LocationLibraryConstants;

public class UpdateLocationReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        final LocationInfo locationInfo = (LocationInfo) intent.getSerializableExtra(LocationLibraryConstants.LOCATION_BROADCAST_EXTRA_LOCATIONINFO);

        if (locationInfo != null) {
            SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(context);
            String authToken = settings.getString(Properties.AUTH_TOKEN, "");
            String email = settings.getString(Properties.EMAIL, "");

            UpdateLocationTask utl = new UpdateLocationTask(context);
            utl.execute(email, authToken, (double) locationInfo.lastLat, (double) locationInfo.lastLong, (float) locationInfo.lastAccuracy);
            try {
                utl.get();
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        } else {
            Toast.makeText(context, context.getResources().getString(R.string.location_not_available), Toast.LENGTH_LONG).show();
        }
    }
}