package com.geokewpie.tasks;

import android.content.Context;
import com.geokewpie.CallableWithArguments;
import com.geokewpie.network.NetworkTools;
import com.geokewpie.network.Response;

import java.text.MessageFormat;

public class SendRequestTask extends AbstractNetworkTask<String, Void, Response> {

    public SendRequestTask(Context context, CallableWithArguments<Void, Response> callable) {
        super(context, callable);
    }

    @Override
    protected Response doNetworkOperation(String... strings) throws Exception {
        String user = strings[0];
        String email = strings[1];
        String authToken = strings[2];

        String url = MessageFormat.format("https://198.199.109.47:8080/followings/{0}?email={1}&auth_token={2}", user, email, authToken);

        return NetworkTools.sendPost(url);
    }
}
