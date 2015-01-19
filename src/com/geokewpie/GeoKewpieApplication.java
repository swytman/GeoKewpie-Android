package com.geokewpie;

import android.app.AlarmManager;
import android.app.Application;
import com.littlefluffytoys.littlefluffylocationlibrary.LocationLibrary;
import org.acra.ACRA;
import org.acra.annotation.ReportsCrashes;
import org.acra.sender.HttpSender;

@ReportsCrashes(
        formKey = "",
        httpMethod = HttpSender.Method.PUT,
        reportType = HttpSender.Type.JSON,
        formUri = "http://bgdsrn.iriscouch.com/acra-gk/_design/acra-storage/_update/report",
        formUriBasicAuthLogin = "gk",
        formUriBasicAuthPassword = "gk123"
)
public class GeoKewpieApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        ACRA.init(this);
        LocationLibrary.initialiseLibrary(getBaseContext(), AlarmManager.INTERVAL_FIFTEEN_MINUTES, 0, "com.geokewpie");
    }
}
