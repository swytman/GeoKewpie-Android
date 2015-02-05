package com.geokewpie.tasks;

import android.content.Context;
import com.geokewpie.CallableWithArguments;
import com.geokewpie.beans.User;
import com.geokewpie.beans.UserLocation;
import com.geokewpie.network.NetworkTools;
import com.geokewpie.network.Response;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.text.MessageFormat;
import java.util.*;

public class SearchKewpiesTask extends AbstractNetworkTask<String, Void, List<User>> {

    public SearchKewpiesTask(Context context, CallableWithArguments<Void, List<User>> callable) {
        super(context, callable);
    }

    @Override
    protected List<User> doNetworkOperation(String[] params) throws Exception {
        String query = params[0];
        String email = params[1];
        String authToken = params[2];
        String url = MessageFormat.format("https://198.199.109.47:8080/users/find/{0}?email={1}&auth_token={2}", query, email, authToken);

        Response response = NetworkTools.sendGet(url);

        if (response.isSuccessful()) {
            Type listType = new TypeToken<ArrayList<User>>() {
            }.getType();

            List<User> users = new Gson().fromJson(response.getBody(), listType);
            if (users != null) {
                Collections.sort(users, new Comparator<User>() {
                    @Override
                    public int compare(User userA, User userB) {
                        return userA.getLogin().compareTo(userB.getLogin());
                    }
                });
                return users;
            }
        }
        return Collections.emptyList();
    }
}
