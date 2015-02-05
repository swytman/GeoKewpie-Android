package com.geokewpie.tasks;

import android.content.Context;
import android.widget.Toast;
import com.geokewpie.R;
import com.geokewpie.network.NetworkTools;
import com.geokewpie.network.Response;

import java.text.MessageFormat;


public class RequestLocationsRefreshTask extends AbstractNetworkTask<String, Void, Response> {
    public RequestLocationsRefreshTask(Context context) {
        super(context);
    }

    @Override
    protected Response doNetworkOperation(String... strings) throws Exception {
        String email = strings[0];
        String authToken = strings[1];

        String url = MessageFormat.format("https://198.199.109.47:8080/followings/update_locations?email={0}&auth_token={1}", email, authToken);

        return NetworkTools.sendGet(url);
    }

    @Override
    protected void onPostExecute(Response response) {
        if (response != null && response.isSuccessful()) {
            Toast.makeText(context, context.getResources().getString(R.string.locations_to_be_updated), Toast.LENGTH_LONG).show();
        }
    }
}
