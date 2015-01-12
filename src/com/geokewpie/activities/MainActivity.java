package com.geokewpie.activities;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Handler;
import android.preference.PreferenceManager;
import android.view.Menu;
import android.view.MenuItem;
import com.geokewpie.Properties;
import com.geokewpie.R;
import com.geokewpie.beans.UserLocation;
import com.geokewpie.services.UpdateLocationService;
import com.geokewpie.tasks.GetFollowingsTask;
import com.geokewpie.tasks.UpdateLocationTask;
import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.model.*;

import java.util.*;
import java.util.concurrent.ExecutionException;

public class MainActivity extends Activity {

    public static final double INITIAL_MAP_BOUNDS = 0.1;

    private LocationManager locationManager;
    private GoogleMap map;
    private Marker marker;

    private Map<String, Marker> usersMarkersMap = new HashMap<String, Marker>();

    private boolean initialMapBoundsSet = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! startService");
        startService(new Intent(this, UpdateLocationService.class));

        locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);

        map = ((MapFragment) getFragmentManager().findFragmentById(R.id.map)).getMap();

        marker = map.addMarker((new MarkerOptions()).position(new LatLng(0, 0)).title("Me"));

        SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
        final String authToken = settings.getString(Properties.AUTH_TOKEN, "");
        final String email = settings.getString(Properties.EMAIL, "");


        Timer myTimer = new Timer();
        final Handler uiHandler = new Handler();
        myTimer.schedule(new TimerTask() {
            @Override
            public void run() {
                GetFollowingsTask flt = new GetFollowingsTask();
                flt.execute(email, authToken);

                final List<UserLocation> followings;
                try {
                    followings = flt.get();
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                } catch (ExecutionException e) {
                    throw new RuntimeException(e);
                }

                uiHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        for (UserLocation following : followings) {
                            Marker marker = usersMarkersMap.get(following.getLogin());
                            if (marker == null) {
                                marker = map.addMarker(
                                        (new MarkerOptions())
                                                .position(new LatLng(following.getLatitude(), following.getLongitude()))
                                                .title(following.getLogin())
                                                .icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_AZURE))
                                );
                                usersMarkersMap.put(following.getLogin(), marker);
                            } else {
                                marker.setPosition(new LatLng(following.getLatitude(), following.getLongitude()));
                            }
                        }
                    }
                });
            }
        }, 0L, 60L * 1000); // 1 min interval
    }


    @Override
    protected void onResume() {
        super.onResume();
        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 1000 * 10, 10, locationListener);
        locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 1000 * 10, 300, locationListener);
    }

    @Override
    protected void onPause() {
        super.onPause();
        locationManager.removeUpdates(locationListener);
    }

    private LocationListener locationListener = new LocationListener() {

        @Override
        public void onLocationChanged(Location location) {
            marker.setPosition(new LatLng(location.getLatitude(), location.getLongitude()));

            if (!initialMapBoundsSet) {
                CameraUpdate cu = CameraUpdateFactory.newLatLngBounds(
                        new LatLngBounds.Builder().include(new LatLng(location.getLatitude() + INITIAL_MAP_BOUNDS, location.getLongitude() + INITIAL_MAP_BOUNDS)).include(new LatLng(location.getLatitude() - INITIAL_MAP_BOUNDS, location.getLongitude() - INITIAL_MAP_BOUNDS)).build(), 0);
                map.animateCamera(cu);

                initialMapBoundsSet = true;
            }

            SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
            String authToken = settings.getString(Properties.AUTH_TOKEN, "");
            String email = settings.getString(Properties.EMAIL, "");

            new UpdateLocationTask().execute(email, authToken, location.getLatitude(), location.getLongitude());
        }

        @Override
        public void onProviderDisabled(String provider) {
        }

        @Override
        public void onProviderEnabled(String provider) {
        }

        @Override
        public void onStatusChanged(String provider, int status, Bundle extras) {
        }
    };

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        switch (id) {
            case R.id.menu_add:
                Intent i = new Intent(getApplicationContext(), AddActivity.class);
                startActivity(i);
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public void onBackPressed() {

    }
}
