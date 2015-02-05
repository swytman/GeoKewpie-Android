package com.geokewpie.activities;

import android.content.*;
import android.content.res.Configuration;
import android.graphics.Color;
import android.location.Location;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.*;
import android.widget.*;
import com.geokewpie.CallableWithArguments;
import com.geokewpie.R;
import com.geokewpie.beans.*;
import com.geokewpie.content.Properties;
import com.geokewpie.drawer.GKNavigationAdapter;
import com.geokewpie.drawer.models.*;
import com.geokewpie.gcm.RegistrationTools;
import com.geokewpie.network.NetworkTools;
import com.geokewpie.network.Response;
import com.geokewpie.tasks.*;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.google.android.gms.maps.*;
import com.google.android.gms.maps.model.*;
import com.google.gson.Gson;

import java.io.IOException;
import java.text.MessageFormat;
import java.util.*;
import java.util.concurrent.*;

public class MainActivity extends ActionBarActivity implements GoogleMap.OnMarkerClickListener {
    private final static int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
    private final static float INITIAL_ZOOM = 12;

    private static final String TAG = "MainActivity";

    private Context context;

    private ActionBarDrawerToggle toggle;
    private DrawerLayout drawerLayout;
    private GKNavigationAdapter navigationAdapter;

    private GoogleCloudMessaging gcm;
    private String regId;

    private GoogleMap map;

    private ScheduledExecutorService exec;

    private String email;
    private String authToken;

    private Map<String, Marker> usersMarkersMap = new HashMap<String, Marker>();
    private Map<String, Circle> usersAccuracyMap = new HashMap<String, Circle>();
    private Map<Marker, DeviceLocation> markerLocationMap = new HashMap<Marker, DeviceLocation>();
    private List<INavigationItemModel> drawerModels;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        // Check device for Play Services APK.
        if (!checkPlayServices()) {
            return;
        }

        context = getApplicationContext();

        SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(context);

        email = settings.getString(Properties.EMAIL, "");
        authToken = settings.getString(Properties.AUTH_TOKEN, "");

        if ("".equals(authToken)) { // todo check if token is not expired
            Intent i = new Intent(context, RegisterActivity.class);
            startActivity(i);
            finish();
        } else {

            gcm = GoogleCloudMessaging.getInstance(context);

            String regId = RegistrationTools.getRegistrationId(context, settings);

            if (regId.isEmpty()) {
                registerInBackground();
            }

            Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
            setSupportActionBar(toolbar);

            getSupportActionBar().setTitle(settings.getString(Properties.LOGIN, getResources().getString(R.string.app_name)));

            drawerLayout = (DrawerLayout) findViewById(R.id.main_drawer_layout);

            toggle = new ActionBarDrawerToggle(
                    this,
                    drawerLayout,
                    R.string.navigation_drawer_open,
                    R.string.navigation_drawer_close
            );

            toggle.setDrawerIndicatorEnabled(true);
            // Set the drawer toggle as the DrawerListener
            drawerLayout.setDrawerListener(toggle);

            final ListView drawerList = (ListView) findViewById(R.id.left_drawer);

            drawerModels = new ArrayList<INavigationItemModel>();
            drawerModels.add(new LabelNavigationItemModel(getResources().getString(R.string.loading)));

            // Set the adapter for the list view
            navigationAdapter = new GKNavigationAdapter(context, drawerModels);
            drawerList.setAdapter(navigationAdapter);
            // Set the list's click listener
            drawerList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> adapterView, View view, int position, long id) {
                    INavigationItemModel itemModel = drawerModels.get(position);
                    if (itemModel instanceof FollowingNavigationItemModel) {
                        FollowingNavigationItemModel followingNavigationItemModel = (FollowingNavigationItemModel) itemModel;
                        drawerLayout.closeDrawer((View) drawerList.getParent());
                        float zoom = map.getCameraPosition().zoom;
                        CameraUpdate cameraUpdate = CameraUpdateFactory.newLatLngZoom(new LatLng(followingNavigationItemModel.getDeviceLocation().getLatitude(), followingNavigationItemModel.getDeviceLocation().getLongitude()), Math.max(zoom, INITIAL_ZOOM));
                        map.animateCamera(cameraUpdate);

                        onMarkerClick(getMarkerByDeviceLocation(followingNavigationItemModel.getDeviceLocation()));
                    }
                }
            });

            defineOnClickForDrawerLayouts();

            map = ((MapFragment) getFragmentManager().findFragmentById(R.id.map)).getMap();
            map.setOnMarkerClickListener(this);
            map.setMyLocationEnabled(true);
            map.getUiSettings().setZoomControlsEnabled(true);

            map.setOnMyLocationChangeListener(new GoogleMap.OnMyLocationChangeListener() {
                @Override
                public void onMyLocationChange(Location location) {
                    CameraUpdate cameraUpdate = CameraUpdateFactory.newLatLngZoom(
                            new LatLng(location.getLatitude(), location.getLongitude()), INITIAL_ZOOM);
                    map.animateCamera(cameraUpdate);
                    map.setOnMyLocationChangeListener(null);
                }
            });
        }
    }

    private void defineOnClickForDrawerLayouts() {
        defineOnClickForDrawerLayout(R.id.add_kewpie_layout, AddActivity.class);
        defineOnClickForDrawerLayout(R.id.followers_layout, FollowersActivity.class);
//        defineOnClickForDrawerLayout(R.id.settings_layout, SettingsActivity.class);
        defineOnClickForDrawerLayout(R.id.faq_layout, FAQActivity.class);
    }

    private void defineOnClickForDrawerLayout(int layoutId, final Class activityClass) {
        LinearLayout addKewpieLayout = (LinearLayout) findViewById(layoutId);
        addKewpieLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent i = new Intent(context, activityClass);
                startActivity(i);
            }
        });
    }

    private Marker getMarkerByDeviceLocation(DeviceLocation deviceLocation) {
        for (Marker marker : markerLocationMap.keySet()) {
            if (deviceLocation.equals(markerLocationMap.get(marker))) {
                return marker;
            }
        }
        return null;
    }

    private void prepareDrawerData(List<UserLocation> userLocations) {
        drawMarkers(userLocations);

        drawerModels = new ArrayList<INavigationItemModel>();
//        drawerModels.add(new HeaderNavigationItemModel(getResources().getString(R.string.you_are_following)));

        System.out.println("!!!!! userLocations = " + userLocations);
        for (UserLocation userLocation : userLocations) {
            for (DeviceLocation deviceLocation : userLocation.getDevices()) {
                drawerModels.add(new FollowingNavigationItemModel(userLocation.getLogin(), deviceLocation, context));
            }
        }

        if (userLocations.isEmpty()) {
            drawerModels.add(new LabelNavigationItemModel(getResources().getString(R.string.no_active_followings)));
        }

        navigationAdapter.clear();
        navigationAdapter.addAll(drawerModels);
        navigationAdapter.notifyDataSetChanged();

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
        if (toggle.onOptionsItemSelected(item))
            return true;

        int id = item.getItemId();

        switch (id) {
            case R.id.menu_refresh:
                new RequestLocationsRefreshTask(context).execute(email, authToken);
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public boolean onMarkerClick(Marker marker) {
        marker.setSnippet(markerLocationMap.get(marker).updatedAgo(context));
        marker.showInfoWindow();
        return true;
    }

    @Override
    protected void onResume() {
        super.onResume();

        checkPlayServices();

        new RequestLocationsRefreshTask(context).execute(email, authToken);

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

            new GetFollowingsLocationsTask(context, new CallableWithArguments<Void, List<UserLocation>>() {
                @Override
                public Void call(final List<UserLocation> userLocations) throws Exception {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            prepareDrawerData(userLocations);
                        }
                    });

                    return null;
                }
            }).execute(email, authToken);
        }
    }

    private void drawMarkers(List<UserLocation> userLocations) {
        for (UserLocation following : userLocations) {
            for (DeviceLocation deviceLocation : following.getDevices()) {
                LatLng latLng = new LatLng(deviceLocation.getLatitude(), deviceLocation.getLongitude());
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
                markerLocationMap.put(marker, deviceLocation);
                drawAccuracyCircle(following.getLogin(), latLng, deviceLocation.getAccuracy());
            }
        }
    }

    /**
     * Check the device to make sure it has the Google Play Services APK. If
     * it doesn't, display a dialog that allows users to download the APK from
     * the Google Play Store or enable it in the device's system settings.
     */
    private boolean checkPlayServices() {
        int resultCode = GooglePlayServicesUtil.isGooglePlayServicesAvailable(this);
        if (resultCode != ConnectionResult.SUCCESS) {
            if (GooglePlayServicesUtil.isUserRecoverableError(resultCode)) {
                GooglePlayServicesUtil.getErrorDialog(resultCode, this,
                        PLAY_SERVICES_RESOLUTION_REQUEST).show();
            } else {
                Log.i(TAG, getResources().getString(R.string.device_is_not_supported));
                finish();
            }
            return false;
        }
        return true;
    }

    /**
     * Registers the application with GCM servers asynchronously.
     * <p/>
     * Stores the registration ID and app versionCode in the application's
     * shared preferences.
     */
    private void registerInBackground() {
        new AbstractNetworkTask<Void, Void, String>(context) {
            @Override
            protected String doNetworkOperation(Void[] params) throws Exception {
                try {
                    if (gcm == null) {
                        gcm = GoogleCloudMessaging.getInstance(context);
                    }
                    regId = gcm.register(RegistrationTools.SENDER_ID);

                    String url = MessageFormat.format("https://198.199.109.47:8080/devices?email={0}&auth_token={1}", email, authToken);
                    Response response = NetworkTools.sendPost(url, new Gson().toJson(new Device(regId, context)));

                    if (response.isSuccessful()) {
                        RegistrationTools.storeRegistrationId(context, regId);
                    }
                } catch (IOException ex) {
                    throw new RuntimeException(ex);
                }
                return null;
            }

        }.execute(null, null, null);
    }

    @Override
    protected void onPostCreate(Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        toggle.syncState();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        toggle.onConfigurationChanged(newConfig);
    }
}