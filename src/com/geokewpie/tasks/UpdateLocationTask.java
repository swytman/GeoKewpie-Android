package com.geokewpie.tasks;

import android.content.Context;
import android.telephony.TelephonyManager;
import com.geokewpie.beans.DeviceLocation;
import com.geokewpie.network.NetworkTools;
import com.geokewpie.network.Response;
import com.google.gson.Gson;

import java.text.MessageFormat;
import java.util.Date;


public class UpdateLocationTask extends AbstractNetworkTask<Object, Void, Response> {
    public UpdateLocationTask(Context context) {
        super(context);
    }

    @Override
    protected Response doNetworkOperation(Object... objects) throws Exception {
        System.out.println("ALBA UpdateLocationService.doNetworkOperation 0");
        String email = (String) objects[0];
        String authToken = (String) objects[1];
        Double latitude = (Double) objects[2];
        Double longitude = (Double) objects[3];
        Float accuracy = (Float) objects[4];
        Date dateOfLocationFix = (Date) objects[5];

        String deviceCode = ((TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE)).getDeviceId();


        String url = MessageFormat.format("https://198.199.109.47:8080/locations?email={0}&auth_token={1}", email, authToken);

        DeviceLocation deviceLocation = new DeviceLocation(latitude, longitude, accuracy, dateOfLocationFix, deviceCode);

        System.out.println("ALBA UpdateLocationService.doNetworkOperation 1");

        Response response = NetworkTools.sendPost(url, new Gson().toJson(deviceLocation));

        System.out.println("ALBA UpdateLocationService.doNetworkOperation 2 response = " + response);

        return response;
    }
}
