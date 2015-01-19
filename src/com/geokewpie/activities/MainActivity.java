package com.geokewpie.activities;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.location.Location;
import android.os.Bundle;
import android.os.Handler;
import android.preference.PreferenceManager;
import android.view.Menu;
import android.view.MenuItem;
import com.geokewpie.R;
import com.geokewpie.beans.UserLocation;
import com.geokewpie.content.Properties;
import com.geokewpie.tasks.GetFollowingsTask;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
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

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class MainActivity extends Activity implements LocationListener, GoogleMap.OnMarkerClickListener, GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener {
    public static final String DATE_DELIMITER = "|";

    private GoogleMap map;
    private GoogleApiClient googleApiClient;

    private Handler uiHandler;
    private ScheduledExecutorService exec;

    private String email;
    private String authToken;

    private Marker myMarker;
    private Map<String, Marker> usersMarkersMap = new HashMap<String, Marker>();
    private Map<String, Circle> usersAccuracyMap = new HashMap<String, Circle>();
    private Map<Marker, DateTime> markerDateTimeMap = new HashMap<Marker, DateTime>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
        authToken = settings.getString(Properties.AUTH_TOKEN, "");
        email = settings.getString(Properties.EMAIL, "");

        if ("".equals(authToken)) { // todo check if token is not expired
            Intent i = new Intent(getApplicationContext(), RegisterActivity.class);
            startActivity(i);
            finish();
        }

        map = ((MapFragment) getFragmentManager().findFragmentById(R.id.map)).getMap();
        map.setOnMarkerClickListener(this);

        googleApiClient = new GoogleApiClient.Builder(this)
                .addApi(LocationServices.API)
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this)
                .build();
        googleApiClient.connect();

        uiHandler = new Handler();
    }

    private String timeAgo(DateTime dateTime) {
        if (dateTime == null) return "";

        PeriodFormatter periodFormatter = new PeriodFormatterBuilder()
                .appendYears().appendSuffix(" " + getResources().getString(R.string.year), " " + getResources().getString(R.string.years)).appendSeparator(DATE_DELIMITER)
                .appendMonths().appendSuffix(" " + getResources().getString(R.string.month), " " + getResources().getString(R.string.months)).appendSeparator(DATE_DELIMITER)
                .appendWeeks().appendSuffix(" " + getResources().getString(R.string.week), " " + getResources().getString(R.string.weeks)).appendSeparator(DATE_DELIMITER)
                .appendDays().appendSuffix(" " + getResources().getString(R.string.day), " " + getResources().getString(R.string.days)).appendSeparator(DATE_DELIMITER)
                .appendHours().appendSuffix(" " + getResources().getString(R.string.hour), " " + getResources().getString(R.string.hours)).appendSeparator(DATE_DELIMITER)
                .appendMinutes().appendSuffix(" " + getResources().getString(R.string.minute), " " + getResources().getString(R.string.minutes)).appendSeparator(DATE_DELIMITER)
                .appendSeconds().appendSuffix(" " + getResources().getString(R.string.second), " " + getResources().getString(R.string.seconds))
                .printZeroNever()
                .toFormatter();

        String updatedAt = periodFormatter.print(new Period(dateTime, new DateTime())) + DATE_DELIMITER;
        return (updatedAt.length() == 1 ? getResources().getString(R.string.moments) : updatedAt.substring(0, updatedAt.indexOf(DATE_DELIMITER))) + " " + getResources().getString(R.string.ago);
    }

    private void drawAccuracyCircle(String login, LatLng latLng, float accuracy) {
        Circle circle = usersAccuracyMap.get(login);
        if (circle == null) {
            CircleOptions co = new CircleOptions().center(latLng).radius(accuracy).fillColor(Color.argb(30, 0, 0, 255)).strokeWidth(0);

            circle = map.addCircle(co);
            usersAccuracyMap.put(login, circle);
        } else {
            circle.setCenter(latLng);
            circle.setRadius(accuracy);
        }
    }

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
    public void onLocationChanged(Location location) {
        LatLng latLng = new LatLng(location.getLatitude(), location.getLongitude());

        if (myMarker == null) {
            myMarker = map.addMarker(
                    (new MarkerOptions())
                            .position(latLng)
                            .title(getResources().getString(R.string.marker_of_me))
                            .icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_GREEN))
            );

            CameraUpdate cameraUpdate = CameraUpdateFactory.newLatLngZoom(latLng, 10);
            map.animateCamera(cameraUpdate);

        } else {
            myMarker.setPosition(latLng);
        }

        drawAccuracyCircle(getResources().getString(R.string.marker_of_me), latLng, location.getAccuracy());
    }

    @Override
    public boolean onMarkerClick(Marker marker) {
        System.out.println("onMarkerClick");
        marker.setSnippet(timeAgo(markerDateTimeMap.get(marker)));
        marker.showInfoWindow();
        return true;
    }

    @Override
    public void onConnected(Bundle bundle) {
        LocationRequest locationRequest = LocationRequest.create();
        locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
        locationRequest.setInterval(4000);
        locationRequest.setFastestInterval(1000);
        LocationServices.FusedLocationApi.requestLocationUpdates(googleApiClient, locationRequest, this);
    }

    @Override
    public void onConnectionSuspended(int i) {

    }

    @Override
    public void onConnectionFailed(ConnectionResult connectionResult) {

    }

    @Override
    protected void onResume() {
        super.onResume();

        exec = Executors.newSingleThreadScheduledExecutor();
        exec.scheduleAtFixedRate(new FollowingsLocationsRunnable(), 0, 10, TimeUnit.SECONDS);
    }

    @Override
    protected void onPause() {
        super.onPause();

        exec.shutdown();
    }

    public class FollowingsLocationsRunnable implements Runnable {
        @Override
        public void run() {

            GetFollowingsTask flt = new GetFollowingsTask(getApplicationContext());
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
                    if (followings == null) return;

                    for (UserLocation following : followings) {
                        DateTime dateTime = null;
                        if (following.getUpdated_at() != null) {
                            DateTimeFormatter isoFormatter = ISODateTimeFormat.dateTime();
                            try { // todo remove once server issue fixed
                                dateTime = isoFormatter.parseDateTime(following.getUpdated_at());
                            } catch (Exception e) {
                                // do nothing
                            }
                        }
                        LatLng latLng = new LatLng(following.getLatitude(), following.getLongitude());
                        Marker marker = usersMarkersMap.get(following.getLogin());
                        if (marker == null) {
                            marker = map.addMarker(
                                    (new MarkerOptions())
                                            .position(latLng)
                                            .title(following.getLogin())
                                            .icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_AZURE))
                            );
                            usersMarkersMap.put(following.getLogin(), marker);
                        } else {
                            marker.setPosition(latLng);
                        }
                        markerDateTimeMap.put(marker, dateTime);
                        drawAccuracyCircle(following.getLogin(), latLng, following.getAccuracy());
                    }
                }
            });
        }
    }
}
