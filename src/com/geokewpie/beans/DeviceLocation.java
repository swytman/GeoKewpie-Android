package com.geokewpie.beans;

import android.content.Context;
import android.os.Build;
import com.geokewpie.R;
import org.joda.time.DateTime;
import org.joda.time.Period;
import org.joda.time.format.*;

import java.util.Date;

public class DeviceLocation {
    private double latitude;
    private double longitude;
    private float accuracy;
    private String updated_at;
    private Date location_update_date;
    private String device_code;
    private String device_model = Build.MODEL;

    public DeviceLocation(double latitude, double longitude, float accuracy, Date location_update_date, String device_code) {
        this.latitude = latitude;
        this.longitude = longitude;
        this.accuracy = accuracy;
        this.location_update_date = location_update_date;
        this.device_code = device_code;
    }

    @Override
    public String toString() {
        return "DeviceLocation{" +
                "device_model='" + device_model + '\'' +
                ", device_code='" + device_code + '\'' +
                ", location_update_date=" + location_update_date +
                ", updated_at='" + updated_at + '\'' +
                ", accuracy=" + accuracy +
                ", longitude=" + longitude +
                ", latitude=" + latitude +
                '}';
    }

    public String updatedAgo(Context context) {
        if (updated_at == null) return "";

        DateTime dateTime = null;
        DateTimeFormatter isoFormatter = ISODateTimeFormat.dateTime();
        try { // todo remove once server issue fixed
            dateTime = isoFormatter.parseDateTime(updated_at);
        } catch (Exception e) {
            // do nothing
        }

        PeriodFormatter periodFormatter = new PeriodFormatterBuilder()
                .appendYears().appendSuffix(" " + context.getResources().getString(R.string.year), " " + context.getResources().getString(R.string.years)).appendSeparator(UserLocation.DATE_DELIMITER)
                .appendMonths().appendSuffix(" " + context.getResources().getString(R.string.month), " " + context.getResources().getString(R.string.months)).appendSeparator(UserLocation.DATE_DELIMITER)
                .appendWeeks().appendSuffix(" " + context.getResources().getString(R.string.week), " " + context.getResources().getString(R.string.weeks)).appendSeparator(UserLocation.DATE_DELIMITER)
                .appendDays().appendSuffix(" " + context.getResources().getString(R.string.day), " " + context.getResources().getString(R.string.days)).appendSeparator(UserLocation.DATE_DELIMITER)
                .appendHours().appendSuffix(" " + context.getResources().getString(R.string.hour), " " + context.getResources().getString(R.string.hours)).appendSeparator(UserLocation.DATE_DELIMITER)
                .appendMinutes().appendSuffix(" " + context.getResources().getString(R.string.minute), " " + context.getResources().getString(R.string.minutes)).appendSeparator(UserLocation.DATE_DELIMITER)
                .appendSeconds().appendSuffix(" " + context.getResources().getString(R.string.second), " " + context.getResources().getString(R.string.seconds))
                .printZeroNever()
                .toFormatter();

        String updatedAt = periodFormatter.print(new Period(dateTime, new DateTime())) + UserLocation.DATE_DELIMITER;
        return updatedAt.length() == 1 ? context.getResources().getString(R.string.now) : updatedAt.substring(0, updatedAt.indexOf(UserLocation.DATE_DELIMITER)) + " " + context.getResources().getString(R.string.ago);
    }

    public String updatedAgo(Context context, boolean isShort) { // todo rewrite to support localization
        String updatedAgo = updatedAgo(context);
        if (isShort && updatedAgo.contains(" ")) {
            updatedAgo = updatedAgo.substring(0, updatedAgo.indexOf(" ") + 2).replace(" ", "");
        }
        return updatedAgo;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public float getAccuracy() {
        return accuracy;
    }

    public void setAccuracy(float accuracy) {
        this.accuracy = accuracy;
    }

    public String getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(String updated_at) {
        this.updated_at = updated_at;
    }

    public Date getLocation_update_date() {
        return location_update_date;
    }

    public void setLocation_update_date(Date location_update_date) {
        this.location_update_date = location_update_date;
    }

    public String getDevice_code() {
        return device_code;
    }

    public void setDevice_code(String device_code) {
        this.device_code = device_code;
    }

    public String getDevice_model() {
        return device_model;
    }

    public void setDevice_model(String device_model) {
        this.device_model = device_model;
    }
}
