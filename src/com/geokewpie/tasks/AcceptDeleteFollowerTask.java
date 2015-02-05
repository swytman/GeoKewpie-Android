package com.geokewpie.tasks;

import android.content.Context;
import com.geokewpie.CallableWithArguments;
import com.geokewpie.network.NetworkTools;

import java.text.MessageFormat;

public class AcceptDeleteFollowerTask extends AbstractNetworkTask<String, Void, Void> {
    public AcceptDeleteFollowerTask(Context context, CallableWithArguments<Void, Void> callable) {
        super(context, callable);
    }

    @Override
    protected Void doNetworkOperation(String[] params) throws Exception {
        String login = params[0];
        String email = params[1];
        String authToken = params[2];
        String method = params[3];

        String url = MessageFormat.format("https://198.199.109.47:8080/followers/{0}?email={1}&auth_token={2}", login, email, authToken);
        NetworkTools.sendRequest(url, null, method);

        return null;
    }
}
