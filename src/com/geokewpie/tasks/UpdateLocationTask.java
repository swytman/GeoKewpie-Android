package com.geokewpie.tasks;

import android.os.AsyncTask;
import com.geokewpie.beans.UserLocation;
import com.geokewpie.network.NetworkTools;
import com.geokewpie.network.Response;
import com.google.gson.Gson;

import java.text.MessageFormat;


public class UpdateLocationTask extends AsyncTask<Object, Void, Response> {
    @Override
    protected Response doInBackground(Object... objects) {

        try {
            String email = (String) objects[0];
            String authToken = (String) objects[1];
            Double latitude = (Double) objects[2];
            Double longitude = (Double) objects[3];

            String url = MessageFormat.format("https://198.199.109.47:8080/locations?email={0}&auth_token={1}", email, authToken);

            UserLocation userLocation = new UserLocation(null, latitude, longitude);

            return NetworkTools.sendPost(url, new Gson().toJson(userLocation));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
