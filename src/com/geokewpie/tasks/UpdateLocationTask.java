package com.geokewpie.tasks;

import android.content.Context;
import com.geokewpie.beans.UserLocation;
import com.geokewpie.network.NetworkTools;
import com.geokewpie.network.Response;
import com.google.gson.Gson;

import java.text.MessageFormat;


public class UpdateLocationTask extends AbstractNetworkTask<Object, Void, Response> {
    public UpdateLocationTask(Context context) {
        super(context);
    }

    @Override
    protected Response doNetworkOperation(Object... objects) throws Exception {
        String email = (String) objects[0];
        String authToken = (String) objects[1];
        Double latitude = (Double) objects[2];
        Double longitude = (Double) objects[3];

        String url = MessageFormat.format("https://198.199.109.47:8080/locations?email={0}&auth_token={1}", email, authToken);

        UserLocation userLocation = new UserLocation(latitude, longitude);

        return NetworkTools.sendPost(url, new Gson().toJson(userLocation));
    }
}
