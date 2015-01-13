package com.geokewpie.activities;

import android.app.Activity;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
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
import com.geokewpie.services.updateLocation.UpdateLocationAlarmReceiver;
import com.geokewpie.tasks.GetFollowingsTask;
import com.geokewpie.tasks.UpdateLocationTask;
import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.model.*;
import org.joda.time.DateTime;
import org.joda.time.Period;
import org.joda.time.format.DateTimeFormatter;
import org.joda.time.format.ISODateTimeFormat;
import org.joda.time.format.PeriodFormatter;
import org.joda.time.format.PeriodFormatterBuilder;

import java.util.*;
import java.util.concurrent.ExecutionException;

public class MainActivity extends Activity {
    public static final String DATE_DELIMITER = "|";
    public static final double INITIAL_MAP_BOUNDS = 0.1;

    private LocationManager locationManager;
    private GoogleMap map;
//    private Marker marker;

    private Map<String, Marker> usersMarkersMap = new HashMap<String, Marker>();

    private boolean initialMapBoundsSet = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
        final String authToken = settings.getString(Properties.AUTH_TOKEN, "");
        final String email = settings.getString(Properties.EMAIL, "");
        System.out.println("authToken = " + authToken);

        if ("".equals(authToken)) { // todo check if token is not expired
            Intent i = new Intent(getApplicationContext(), RegisterActivity.class);
            startActivity(i);
            finish();
        }

        System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! startService");
        runService();

        locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);

        map = ((MapFragment) getFragmentManager().findFragmentById(R.id.map)).getMap();
        map.setMyLocationEnabled(true);

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
                            String updatedAt = "";
                            if (following.getUpdated_at() != null) {
                                DateTimeFormatter isoFormatter = ISODateTimeFormat.dateTime();
                                DateTime dateTime = isoFormatter.parseDateTime(following.getUpdated_at());

                                PeriodFormatter periodFormatter = new PeriodFormatterBuilder()
                                        .appendYears().appendSuffix(" " + getResources().getString(R.string.year), " " + getResources().getString(R.string.years)).appendSeparator(DATE_DELIMITER)
                                        .appendMonths().appendSuffix(" " + getResources().getString(R.string.month), " " + getResources().getString(R.string.months)).appendSeparator(DATE_DELIMITER)
                                        .appendWeeks().appendSuffix(" " + getResources().getString(R.string.week), " " + getResources().getString(R.string.weeks)).appendSeparator(DATE_DELIMITER)
                                        .appendDays().appendSuffix(" " + getResources().getString(R.string.day), " " + getResources().getString(R.string.days)).appendSeparator(DATE_DELIMITER)
                                        .appendHours().appendSuffix(" " + getResources().getString(R.string.hour), " " + getResources().getString(R.string.hours)).appendSeparator(DATE_DELIMITER)
                                        .appendMinutes().appendSuffix(" " + getResources().getString(R.string.minute), " " + getResources().getString(R.string.minutes)).appendSeparator(DATE_DELIMITER)
                                        .appendSeconds().appendSuffix(" " + getResources().getString(R.string.second), " " + getResources().getString(R.string.seconds)).appendSeparator(DATE_DELIMITER)
                                        .printZeroNever()
                                        .toFormatter();

                                updatedAt = periodFormatter.print(new Period(dateTime, new DateTime()));
                                System.out.println("updatedAt = " + updatedAt);
                                updatedAt = updatedAt.substring(0, updatedAt.indexOf(DATE_DELIMITER)) + " " + getResources().getString(R.string.ago);
                            }
                            LatLng latlng = new LatLng(following.getLatitude(), following.getLongitude());
                            Marker marker = usersMarkersMap.get(following.getLogin());
                            if (marker == null) {
                                marker = map.addMarker(
                                        (new MarkerOptions())
                                                .position(latlng)
                                                .title(following.getLogin())
                                                .snippet(updatedAt)
                                                .icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_AZURE))
                                );
                                usersMarkersMap.put(following.getLogin(), marker);
                            } else {
                                marker.setPosition(latlng);
                                marker.setSnippet(updatedAt);
                            }
                        }
                    }
                });
            }
        }, 0L, 60L * 1000); // 1 min interval
    }

    private void runService() {
        Intent myAlarm = new Intent(getApplicationContext(), UpdateLocationAlarmReceiver.class);
        PendingIntent recurringAlarm = PendingIntent.getBroadcast(getApplicationContext(), 0, myAlarm, PendingIntent.FLAG_CANCEL_CURRENT);
        AlarmManager alarms = (AlarmManager) this.getSystemService(Context.ALARM_SERVICE);
        Calendar updateTime = Calendar.getInstance();
        alarms.setInexactRepeating(AlarmManager.RTC_WAKEUP, updateTime.getTimeInMillis(), AlarmManager.INTERVAL_FIFTEEN_MINUTES, recurringAlarm);
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
/*
            LatLng latlng = new LatLng(location.getLatitude(), location.getLongitude());
            if (marker == null) {
                marker = map.addMarker((new MarkerOptions()).position(latlng).title(getResources().getString(R.string.marker_of_me)));
            } else {
                marker.setPosition(latlng);
            }
*/

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
