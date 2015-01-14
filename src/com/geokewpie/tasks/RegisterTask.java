package com.geokewpie.tasks;

import android.content.Context;
import com.geokewpie.beans.User;
import com.geokewpie.network.NetworkTools;
import com.geokewpie.network.Response;
import com.google.gson.Gson;

public class RegisterTask extends AbstractNetworkTask<String, Void, Response> {
    public RegisterTask(Context context) {
        super(context);
    }

    @Override
    protected Response doNetworkOperation(String... strings) throws Exception {
        User user = new User(strings[0], strings[1], strings[2]);

        return NetworkTools.sendPost("https://198.199.109.47:8080/users", new Gson().toJson(user));
    }
}
