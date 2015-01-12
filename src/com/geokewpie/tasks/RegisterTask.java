package com.geokewpie.tasks;

import android.os.AsyncTask;
import com.geokewpie.beans.User;
import com.geokewpie.network.NetworkTools;
import com.geokewpie.network.Response;
import com.google.gson.Gson;

public class RegisterTask extends AsyncTask<String, Void, Response> {
    @Override
    protected Response doInBackground(String... strings) {

        try {
            User user = new User(strings[0], strings[1], strings[2]);

            return NetworkTools.sendPost("https://198.199.109.47:8080/users", new Gson().toJson(user));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
