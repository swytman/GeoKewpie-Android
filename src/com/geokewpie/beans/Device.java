package com.geokewpie.beans;

import android.content.Context;
import android.os.Build;
import android.telephony.TelephonyManager;
import com.geokewpie.gcm.RegistrationTools;

public class Device {

    private String model = Build.MODEL;
    private String manufacturer = Build.MANUFACTURER;
    private String platform = "Android";
    private String os_version = Build.VERSION.RELEASE;

    private String gcm_reg_id;
    private String device_code;
    private String app_version;

    public Device(String gcm_reg_id) {
        this.gcm_reg_id = gcm_reg_id;
    }

    public Device(String gcm_reg_id, Context context) {
        System.out.println("$$$$$$$$");
        this.gcm_reg_id = gcm_reg_id;
        System.out.println("1");
        this.device_code = ((TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE)).getDeviceId();
        System.out.println("2");
        this.app_version = RegistrationTools.getAppVersionName(context);
        System.out.println("3");
    }
}
