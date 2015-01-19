package com.geokewpie.services.updateLocation;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.IBinder;
import android.preference.PreferenceManager;
import android.widget.Toast;
import com.geokewpie.content.Properties;
import com.geokewpie.tasks.UpdateLocationTask;

public class UpdateLocationService extends Service implements LocationListener {
    private LocationManager lm;

    @Override
    public void onLocationChanged(Location location) {
        double latitude = location.getLatitude();
        double longitude = location.getLongitude();

        SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
        String authToken = settings.getString(Properties.AUTH_TOKEN, "");
        String email = settings.getString(Properties.EMAIL, "");

        new UpdateLocationTask(getApplicationContext()).execute(email, authToken, location.getLatitude(), location.getLongitude(), location.getAccuracy());
    }

    @Override
    public void onStatusChanged(String s, int i, Bundle bundle) {

    }

    @Override
    public void onProviderEnabled(String s) {
        lm.requestLocationUpdates(LocationManager.GPS_PROVIDER, 1000 * 10, 0, this);
        lm.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 1000 * 10, 0, this);
    }

    @Override
    public void onProviderDisabled(String s) {

    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! onStartCommand");
        lm = (LocationManager) getSystemService(Context.LOCATION_SERVICE);

        lm.requestLocationUpdates(LocationManager.GPS_PROVIDER, 1000 * 10, 0, this);
        lm.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 1000 * 10, 0, this);

        return super.onStartCommand(intent, flags, startId);
    }
}
