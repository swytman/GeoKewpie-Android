package com.geokewpie.tasks;

import android.content.Context;
import com.geokewpie.CallableWithArguments;
import com.geokewpie.beans.UserLocation;
import com.geokewpie.network.NetworkTools;
import com.geokewpie.network.Response;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.text.MessageFormat;
import java.util.*;


public class GetFollowingsLocationsTask extends AbstractNetworkTask<String, Void, List<UserLocation>> {

    public GetFollowingsLocationsTask(Context context, CallableWithArguments<Void, List<UserLocation>> callable) {
        super(context, callable);
    }

    @Override
    protected List<UserLocation> doNetworkOperation(String... strings) throws Exception {
        String email = strings[0];
        String authToken = strings[1];

        String url = MessageFormat.format("https://198.199.109.47:8080/locations?email={0}&auth_token={1}", email, authToken);

        Response response = NetworkTools.sendGet(url);

        if (response.isSuccessful()) {
            Type listType = new TypeToken<ArrayList<UserLocation>>() {
            }.getType();

            List<UserLocation> locations = new Gson().fromJson(response.getBody(), listType);
            if (locations != null) {
                Collections.sort(locations, new Comparator<UserLocation>() {
                    @Override
                    public int compare(UserLocation locationA, UserLocation locationB) {
                        return locationA.getLogin().compareTo(locationB.getLogin());
                    }
                });
                return locations;
            }
        }
        return Collections.emptyList();
    }
}
