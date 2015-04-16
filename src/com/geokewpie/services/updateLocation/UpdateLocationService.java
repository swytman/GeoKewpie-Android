package com.geokewpie.services.updateLocation;

import android.app.Service;
import android.content.Intent;
import android.content.SharedPreferences;
import android.location.Location;
import android.os.Bundle;
import android.os.IBinder;
import android.preference.PreferenceManager;
import com.geokewpie.content.Properties;
import com.geokewpie.gcm.GcmBroadcastReceiver;
import com.geokewpie.tasks.UpdateLocationTask;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationServices;

import java.util.Date;

public class UpdateLocationService extends Service implements GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener {
    private GoogleApiClient googleApiClient;
    private Intent intent;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
        Boolean invisible = settings.getBoolean(Properties.INVISIBLE, Boolean.FALSE);

        if (Boolean.FALSE.equals(invisible)) {

            this.intent = intent;

            System.out.println("ALBA UpdateLocationService.onStartCommand 0");
            googleApiClient = new GoogleApiClient.Builder(getApplicationContext())
                    .addApi(LocationServices.API)
                    .addConnectionCallbacks(this)
                    .addOnConnectionFailedListener(this)
                    .build();
            googleApiClient.connect();

        }

        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public void onConnected(Bundle bundle) {
        System.out.println("ALBA UpdateLocationService.onConnected");

        Location location = LocationServices.FusedLocationApi.getLastLocation(googleApiClient);

        if (location != null) {
            SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
            String authToken = settings.getString(Properties.AUTH_TOKEN, "");
            String email = settings.getString(Properties.EMAIL, "");

            System.out.println("ALBA UpdateLocationService.onLocationChanged 1");

            new UpdateLocationTask(getApplicationContext()).execute(email, authToken, location.getLatitude(), location.getLongitude(), location.getAccuracy(), new Date(location.getTime()));
            System.out.println("ALBA UpdateLocationService.onLocationChanged 2");
        }

        GcmBroadcastReceiver.completeWakefulIntent(intent);
        System.out.println("ALBA UpdateLocationService.onLocationChanged 3");

        stopSelf();
    }

    @Override
    public void onConnectionSuspended(int i) {
        System.out.println("ALBA UpdateLocationService.onConnectionSuspended");

    }

    @Override
    public void onConnectionFailed(ConnectionResult connectionResult) {
        System.out.println("ALBA UpdateLocationService.onConnectionFailed");
    }
}
