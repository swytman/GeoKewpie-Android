package com.geokewpie.tasks;

import android.os.AsyncTask;
import com.geokewpie.network.NetworkTools;
import com.geokewpie.network.Response;

import java.text.MessageFormat;

public class SendRequestTask extends AsyncTask<String, Void, Response> {
    @Override
    protected Response doInBackground(String... strings) {
        try {
            String user = strings[0];
            String email = strings[1];
            String authToken = strings[2];

            String url = MessageFormat.format("https://198.199.109.47:8080/followings/{0}?email={1}&auth_token={2}", user, email, authToken);

            return NetworkTools.sendPost(url);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
